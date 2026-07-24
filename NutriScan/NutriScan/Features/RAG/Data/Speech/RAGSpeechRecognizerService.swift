//
//  RAGSpeechRecognizerService.swift
//  NutriScan
//

import Foundation
import Speech
import AVFoundation

/// Wraps SFSpeechRecognizer + AVAudioEngine to provide live speech-to-text in
/// either English or Arabic. Shared by the chat input bar (dictation into the
/// text field) and the full-screen voice chat flow.
final class RAGSpeechRecognizerService {
    enum RecognizerError: Error {
        case notAuthorized
        case recognizerUnavailable
    }

    var onTranscriptUpdate: ((String) -> Void)?
    var onFinish: ((String) -> Void)?
    var onError: ((Error) -> Void)?

    private(set) var isListening = false

    private var speechRecognizer: SFSpeechRecognizer?
    private var audioEngine: AVAudioEngine?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var lastTranscript: String = ""

    // MARK: - Silence detection

    /// dB threshold — only silence quieter than this counts.
    private let silenceThresholdDB: Float = -42.0

    /// Seconds of sustained silence after speech before we auto-stop.
    private let silenceTimeout: TimeInterval = 2.0

    /// Hard cap so a broken recognizer never records forever.
    private let maxRecordingDuration: TimeInterval = 30

    private var silenceTimer: Timer?
    private var maxDurationWork: DispatchWorkItem?
    /// True once we've received at least one transcript with actual content.
    /// The silence timer is only armed after speech has been heard, so ambient
    /// noise at the start never triggers a premature stop.
    private var hasHeardSpeech = false

    func start(language: RAGLanguage) {
        guard !isListening else { return }
        requestAuthorization { [weak self] granted in
            guard let self else { return }
            guard granted else {
                self.onError?(RecognizerError.notAuthorized)
                return
            }
            self.beginRecording(language: language)
        }
    }

    func stop() {
        guard isListening || audioEngine != nil else { return }

        cancelTimers()

        audioEngine?.stop()
        audioEngine?.inputNode.removeTap(onBus: 0)
        audioEngine = nil

        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionRequest = nil
        recognitionTask = nil

        isListening = false
        hasHeardSpeech = false
    }

    func deactivateSession() {
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }

    // MARK: - Authorization

    private func requestAuthorization(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { status in
            guard status == .authorized else {
                DispatchQueue.main.async { completion(false) }
                return
            }
            if #available(iOS 17.0, *) {
                AVAudioApplication.requestRecordPermission { granted in
                    DispatchQueue.main.async { completion(granted) }
                }
            } else {
                AVAudioSession.sharedInstance().requestRecordPermission { granted in
                    DispatchQueue.main.async { completion(granted) }
                }
            }
        }
    }

    // MARK: - Recording

    private func beginRecording(language: RAGLanguage) {
        stop()

        let locale = Locale(identifier: language.speechLocaleIdentifier)
        guard let recognizer = SFSpeechRecognizer(locale: locale), recognizer.isAvailable else {
            onError?(RecognizerError.recognizerUnavailable)
            return
        }
        speechRecognizer = recognizer

        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.record, mode: .measurement, options: .duckOthers)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            onError?(error)
            return
        }

        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        recognitionRequest = request

        let engine = AVAudioEngine()
        audioEngine = engine

        let inputNode = engine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 2048, format: recordingFormat) { [weak self] buffer, _ in
            guard let self else { return }
            // Guard against zero-length buffers that can occur during engine
            // start/stop transitions.
            guard buffer.frameLength > 0 else { return }
            self.recognitionRequest?.append(buffer)
            self.checkAudioLevel(buffer: buffer)
        }

        do {
            engine.prepare()
            try engine.start()
        } catch {
            onError?(error)
            return
        }

        isListening = true
        lastTranscript = ""
        hasHeardSpeech = false

        recognitionTask = recognizer.recognitionTask(with: request) { [weak self] result, error in
            guard let self else { return }

            if let result {
                let text = result.bestTranscription.formattedString
                self.lastTranscript = text
                DispatchQueue.main.async { self.onTranscriptUpdate?(text) }

                // Mark that we've heard real speech so the silence timer
                // is allowed to arm itself from now on.
                if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    self.hasHeardSpeech = true
                }

                if result.isFinal {
                    self.stop()
                    if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        DispatchQueue.main.async { self.onFinish?(text) }
                    }
                }
            }

            if error != nil {
                self.stop()
            }
        }

        // Hard timeout
        let work = DispatchWorkItem { [weak self] in
            guard let self, self.isListening else { return }
            let transcript = self.lastTranscript
            self.stop()
            if !transcript.isEmpty {
                self.onFinish?(transcript)
            }
        }
        maxDurationWork = work
        DispatchQueue.main.asyncAfter(deadline: .now() + maxRecordingDuration, execute: work)
    }

    // MARK: - Silence detection via audio power

    private func checkAudioLevel(buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData?[0] else { return }
        let frameLength = Int(buffer.frameLength)
        guard frameLength > 0 else { return }

        var sumOfSquares: Float = 0
        for i in 0..<frameLength {
            let sample = channelData[i]
            sumOfSquares += sample * sample
        }
        let rms = sqrtf(sumOfSquares / Float(frameLength))
        let db = 20 * log10f(rms + 1e-10)

        DispatchQueue.main.async { [weak self] in
            guard let self, self.isListening else { return }
            // Only arm / reset the silence timer AFTER we've actually heard
            // speech.  This prevents ambient noise at the start from starting
            // a countdown that would cut the user off before they even speak.
            guard self.hasHeardSpeech else { return }
            if db > self.silenceThresholdDB {
                self.resetSilenceTimer()
            }
        }
    }

    private func resetSilenceTimer() {
        silenceTimer?.invalidate()
        silenceTimer = Timer.scheduledTimer(withTimeInterval: silenceTimeout, repeats: false) { [weak self] _ in
            guard let self else { return }
            let transcript = self.lastTranscript
            self.stop()
            self.onFinish?(transcript)
        }
    }

    private func cancelTimers() {
        silenceTimer?.invalidate()
        silenceTimer = nil
        maxDurationWork?.cancel()
        maxDurationWork = nil
    }
}
