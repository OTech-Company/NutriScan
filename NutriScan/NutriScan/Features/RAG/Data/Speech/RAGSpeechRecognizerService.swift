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

    /// Called with the latest partial (or final) transcript.
    var onTranscriptUpdate: ((String) -> Void)?
    /// Called once the recognizer reports a final transcript.
    var onFinish: ((String) -> Void)?
    /// Called when recognition fails or authorization is denied.
    var onError: ((Error) -> Void)?

    private(set) var isListening = false

    private var speechRecognizer: SFSpeechRecognizer?
    private var audioEngine: AVAudioEngine?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var lastTranscript: String = ""

    // MARK: - Silence detection

    /// RMS power level (dB) below which we consider the mic "silent".
    private let silenceThresholdDB: Float = -35.0

    /// How many consecutive seconds of silence before we auto-stop.
    private let silenceTimeout: TimeInterval = 1.4

    /// Hard cap so a broken recognizer never records forever.
    private let maxRecordingDuration: TimeInterval = 30

    private var silenceTimer: Timer?
    private var maxDurationWork: DispatchWorkItem?

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
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            guard let self else { return }
            self.recognitionRequest?.append(buffer)
            self.checkAudioLevel(buffer: buffer, format: recordingFormat)
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

        recognitionTask = recognizer.recognitionTask(with: request) { [weak self] result, error in
            guard let self else { return }

            if let result {
                let text = result.bestTranscription.formattedString
                self.lastTranscript = text
                self.onTranscriptUpdate?(text)
                if result.isFinal {
                    self.onFinish?(text)
                    self.stop()
                }
            }

            if error != nil {
                self.stop()
            }
        }

        // Hard timeout so we never record forever
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

    /// Called on every audio buffer tap. Computes RMS power and resets / fires
    /// a silence timer so we stop recording shortly after the user goes quiet.
    private func checkAudioLevel(buffer: AVAudioPCMBuffer, format: AVAudioFormat) {
        guard let channelData = buffer.floatChannelData?[0] else { return }
        let frameLength = Int(buffer.frameLength)
        guard frameLength > 0 else { return }

        var sumOfSquares: Float = 0
        for i in 0..<frameLength {
            let sample = channelData[i]
            sumOfSquares += sample * sample
        }
        let rms = sqrtf(sumOfSquares / Float(frameLength))
        let db = 20 * log10f(rms + 1e-10) // avoid log(0)

        DispatchQueue.main.async { [weak self] in
            guard let self, self.isListening else { return }
            if db > self.silenceThresholdDB {
                self.resetSilenceTimer()
            }
            // If below threshold, let the current timer keep running.
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

    /// Grabs whatever the recognizer has so far.
    func liveTranscript() -> String {
        lastTranscript
    }

    private func cancelTimers() {
        silenceTimer?.invalidate()
        silenceTimer = nil
        maxDurationWork?.cancel()
        maxDurationWork = nil
    }
}
