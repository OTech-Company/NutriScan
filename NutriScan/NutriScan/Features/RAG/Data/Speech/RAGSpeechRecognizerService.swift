//
//  RAGSpeechRecognizerService.swift
//  NutriScan
//
//  Created by Osama Hosam on 24/07/2026.
//


import Foundation
import Speech
import AVFoundation

/// Wraps SFSpeechRecognizer + AVAudioEngine to provide live speech-to-text.
/// Shared by the chat input bar (dictation into the text field) and the
/// full-screen voice chat flow.
final class RAGSpeechRecognizerService {
    enum RecognizerError: LocalizedError {
        case notAuthorized
        case recognizerUnavailable

        var errorDescription: String? {
            switch self {
            case .notAuthorized:
                return "Please allow microphone and speech recognition access to use voice input."
            case .recognizerUnavailable:
                return "Speech recognition isn't available right now."
            }
        }
    }

    /// Called with the latest partial (or final) transcript.
    var onTranscriptUpdate: ((String) -> Void)?
    /// Called once the recognizer reports a final transcript.
    var onFinish: ((String) -> Void)?
    /// Called when recognition fails or authorization is denied.
    var onError: ((Error) -> Void)?

    private(set) var isListening = false

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.current)
    private var audioEngine: AVAudioEngine?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    func start() {
        guard !isListening else { return }
        requestAuthorization { [weak self] granted in
            guard let self else { return }
            guard granted else {
                self.onError?(RecognizerError.notAuthorized)
                return
            }
            self.beginRecording()
        }
    }

    func stop() {
        guard isListening || audioEngine != nil else { return }

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

    private func beginRecording() {
        guard let speechRecognizer, speechRecognizer.isAvailable else {
            onError?(RecognizerError.recognizerUnavailable)
            return
        }

        stop()

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
            self?.recognitionRequest?.append(buffer)
        }

        do {
            engine.prepare()
            try engine.start()
        } catch {
            onError?(error)
            return
        }

        isListening = true

        recognitionTask = speechRecognizer.recognitionTask(with: request) { [weak self] result, error in
            guard let self else { return }

            if let result {
                self.onTranscriptUpdate?(result.bestTranscription.formattedString)
                if result.isFinal {
                    self.onFinish?(result.bestTranscription.formattedString)
                    self.stop()
                }
            }

            if error != nil {
                self.stop()
            }
        }
    }
}
