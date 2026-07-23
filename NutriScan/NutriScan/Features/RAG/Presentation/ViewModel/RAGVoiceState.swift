//
//  RAGVoiceState.swift
//  NutriScan
//
//  Created by Osama Hosam on 24/07/2026.
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
    var liveTranscript: String = ""
    var lastAnswer: String = ""
    var errorMessage: String?

    private var hasSubmittedCurrentTurn = false
    private var silenceTimer: Timer?

    init(queryUseCase: QueryRAGUseCase) {
        self.queryUseCase = queryUseCase
        super.init()
        synthesizer.delegate = self
        configureSpeechService()
    }

    /// Text shown in the transcript card: the live question while listening,
    /// or the assistant's answer while thinking/speaking.
    var displayedText: String {
        switch state {
        case .idle:
            return "Tap the waveform to ask a question"
        case .listening:
            return liveTranscript.isEmpty ? "Listening..." : liveTranscript
        case .thinking:
            return liveTranscript.isEmpty ? "Thinking..." : liveTranscript
        case .speaking:
            return lastAnswer
        case .error:
            return errorMessage ?? "Something went wrong"
        }
    }

    func start() {
        listen()
    }

    func stop() {
        silenceTimer?.invalidate()
        speechService.stop()
        synthesizer.stopSpeaking(at: .immediate)
        state = .idle
    }

    /// Tapping the waveform: stop early while listening, or restart after an error/idle state.
    func toggleListening() {
        switch state {
        case .listening:
            silenceTimer?.invalidate()
            speechService.stop()
            submit(liveTranscript)
        case .idle, .error:
            listen()
        case .thinking, .speaking:
            break
        }
    }

    private func listen() {
        errorMessage = nil
        liveTranscript = ""
        hasSubmittedCurrentTurn = false
        state = .listening
        speechService.start()
    }

    private func configureSpeechService() {
        speechService.onTranscriptUpdate = { [weak self] transcript in
            guard let self else { return }
            self.liveTranscript = transcript
            self.resetSilenceTimer()
        }
        speechService.onFinish = { [weak self] transcript in
            self?.submit(transcript)
        }
        speechService.onError = { [weak self] error in
            guard let self else { return }
            self.errorMessage = error.localizedDescription
            self.state = .error
        }
    }

    /// Speech recognition doesn't always mark a result as "final" quickly, so we
    /// treat ~1.4s of silence (no new partial transcript) as the end of the turn.
    private func resetSilenceTimer() {
        silenceTimer?.invalidate()
        silenceTimer = Timer.scheduledTimer(withTimeInterval: 1.4, repeats: false) { [weak self] _ in
            guard let self else { return }
            self.speechService.stop()
            self.submit(self.liveTranscript)
        }
    }

    private func submit(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !hasSubmittedCurrentTurn else {
            if trimmed.isEmpty { listen() }
            return
        }
        hasSubmittedCurrentTurn = true
        silenceTimer?.invalidate()
        speechService.stop()
        state = .thinking

        Task {
            do {
                let message = try await queryUseCase.execute(question: trimmed)
                await MainActor.run {
                    self.lastAnswer = message.answer ?? "Sorry, I didn't understand that."
                    self.speak(self.lastAnswer)
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.state = .error
                }
            }
        }
    }

    private func speak(_ text: String) {
        state = .speaking
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: Locale.current.identifier)
            ?? AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        synthesizer.speak(utterance)
    }
}

extension RAGVoiceChatViewModel: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        guard state == .speaking else { return }
        listen()
    }
}
