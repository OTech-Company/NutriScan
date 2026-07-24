//
//  RAGVoiceChatViewModel.swift
//  NutriScan
//

import Foundation
import Observation
import AVFoundation

enum RAGVoiceState: Equatable {
    case idle
    case listening
    case thinking
    case speaking
    case error
}

@Observable
final class RAGVoiceChatViewModel: NSObject {
    private let queryUseCase: QueryRAGUseCase
    private let speechService = RAGSpeechRecognizerService()
    private let synthesizer = AVSpeechSynthesizer()

    var state: RAGVoiceState = .idle
    /// Controls which locale the recognizer listens in and the initial UI copy.
    /// The reply is always *spoken* in whichever language the answer is actually in.
    var language: RAGLanguage
    var errorMessage: String?

    // Kept private on purpose: per the product requirement, neither the user's
    // spoken question nor the assistant's answer is ever shown on screen — only spoken.
    private var liveTranscript: String = ""
    private var hasSubmittedCurrentTurn = false

    init(queryUseCase: QueryRAGUseCase, language: RAGLanguage = .deviceDefault) {
        self.queryUseCase = queryUseCase
        self.language = language
        super.init()
        synthesizer.delegate = self
        configureSpeechService()
    }

    /// Short status word only — never the transcript or the answer.
    var statusLabel: String {
        switch state {
        case .idle: return RAGStrings.voiceIdle(language)
        case .listening: return RAGStrings.voiceListening(language)
        case .thinking: return RAGStrings.voiceThinking(language)
        case .speaking: return RAGStrings.voiceSpeaking(language)
        case .error: return errorMessage ?? RAGStrings.voiceGenericError(language)
        }
    }

    func start() {
        listen()
    }

    func stop() {
        speechService.stop()
        synthesizer.stopSpeaking(at: .immediate)
        state = .idle
    }

    func toggleLanguage() {
        language = language.next
        if state == .listening || state == .idle || state == .error {
            listen()
        }
    }

    /// Tapping the waveform or the action button.
    /// Listening → stop & submit. Speaking → interrupt & go back to listening.
    func toggleAction() {
        switch state {
        case .listening:
            speechService.stop()
            submit(liveTranscript)
        case .speaking:
            synthesizer.stopSpeaking(at: .immediate)
            speechService.deactivateSession()
            listen()
        case .idle, .error:
            listen()
        case .thinking:
            break
        }
    }

    private func listen() {
        errorMessage = nil
        liveTranscript = ""
        hasSubmittedCurrentTurn = false
        state = .listening
        speechService.start(language: language)
    }

    private func configureSpeechService() {
        speechService.onTranscriptUpdate = { [weak self] transcript in
            self?.liveTranscript = transcript
        }
        speechService.onFinish = { [weak self] transcript in
            self?.submit(transcript)
        }
        speechService.onError = { [weak self] error in
            guard let self else { return }
            self.errorMessage = self.localizedErrorMessage(for: error)
            self.state = .error
        }
    }

    private func submit(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !hasSubmittedCurrentTurn else {
            if trimmed.isEmpty { listen() }
            return
        }
        hasSubmittedCurrentTurn = true
        speechService.stop()
        state = .thinking

        // Route the query in whichever language was actually spoken.
        let queryLanguage = RAGLanguage.detect(from: trimmed)

        Task {
            do {
                let message = try await queryUseCase.execute(question: trimmed, language: queryLanguage)
                await MainActor.run {
                    self.speak(message.answer ?? "no answer recieved")
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.state = .error
                }
            }
        }
    }

    /// Speaks the answer aloud. This screen never displays the question or the
    /// answer as text — only the spoken result.
    private func speak(_ text: String) {
        state = .speaking

        // Ensure the session is fully inactive before changing category.
        // deactivateSession() is safe to call even if already inactive.
        speechService.deactivateSession()

        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .duckOthers])
            try session.setActive(true)
        } catch {
            self.errorMessage = error.localizedDescription
            self.state = .error
            return
        }

        let utterance = AVSpeechUtterance(string: text)
        let spokenLanguage = RAGLanguage.detect(from: text)
        utterance.voice = AVSpeechSynthesisVoice(language: spokenLanguage.speechLocaleIdentifier)
            ?? AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        synthesizer.speak(utterance)
    }

    private func localizedErrorMessage(for error: Error) -> String {
        if let recognizerError = error as? RAGSpeechRecognizerService.RecognizerError {
            switch recognizerError {
            case .notAuthorized:
                return RAGStrings.micPermissionDenied(language)
            case .recognizerUnavailable:
                return RAGStrings.recognizerUnavailable(language)
            }
        }
        return error.localizedDescription
    }
}

extension RAGVoiceChatViewModel: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        guard state == .speaking else { return }
        // Deactivate playback session so the next listen() can set up .record
        speechService.deactivateSession()
        listen()
    }
}
