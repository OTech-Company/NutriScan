//
//  RAGChatViewModel.swift
//  NutriScan
//

import Foundation
import Observation

@Observable
final class RAGChatViewModel {
    var messages: [RAGMessage] = []
    var inputText: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    var isDictating: Bool = false

    /// Controls UI copy (placeholders, header title) and the speech recognizer's
    /// listening locale. Each individual query's language is auto-detected from
    /// whatever the user actually typed or said (see `send()`), so the user is
    /// always free to write or speak in either English or Arabic.
    var language: RAGLanguage = .deviceDefault

    /// Exposed (not private) so the chat view can hand it to the voice chat flow.
    let queryUseCase: QueryRAGUseCase

    private let speechService = RAGSpeechRecognizerService()
    private var textBeforeDictation: String = ""

    init(queryUseCase: QueryRAGUseCase) {
        self.queryUseCase = queryUseCase
        configureSpeechService()
    }

    var canSend: Bool {
        !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isLoading
    }

    func toggleLanguage() {
        if isDictating {
            stopDictation()
        }
        language = language.next
    }

    func send() {
        let question = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !question.isEmpty, !isLoading else { return }

        if isDictating {
            stopDictation()
        }

        inputText = ""
        errorMessage = nil

        // Detect the question's language from what was actually typed/spoken,
        // independent of the UI language toggle.
        let queryLanguage = RAGLanguage.detect(from: question)

        // Show the user's message in the chat immediately, then fire the request.
        let pendingMessage = RAGMessage(query: question, language: queryLanguage)
        messages.append(pendingMessage)

        Task {
            await performQuery(question, language: queryLanguage, messageID: pendingMessage.id)
        }
    }

    private func performQuery(_ question: String, language: RAGLanguage, messageID: UUID) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await queryUseCase.execute(question: question, language: language)
            updateMessage(messageID, answer: result.answer, sources: result.sources)
        } catch {
            updateMessage(messageID, isFailed: true)
            errorMessage = error.localizedDescription
        }
    }

    private func updateMessage(_ id: UUID, answer: String? = nil, sources: [RAGSource] = [], isFailed: Bool = false) {
        guard let index = messages.firstIndex(where: { $0.id == id }) else { return }
        messages[index].answer = answer
        messages[index].sources = sources
        messages[index].isFailed = isFailed
    }

    // MARK: - Dictation (speech-to-text into the input field)

    func toggleDictation() {
        isDictating ? stopDictation() : startDictation()
    }

    private func startDictation() {
        guard !isLoading else { return }
        errorMessage = nil
        textBeforeDictation = inputText
        print(inputText)
        isDictating = true
        speechService.start(language: language)
    }

    private func stopDictation() {
        isDictating = false
        speechService.stop()
        speechService.deactivateSession()
    }

    private func configureSpeechService() {
        speechService.onTranscriptUpdate = { [weak self] transcript in
            guard let self else { return }
            let separator = self.textBeforeDictation.isEmpty ? "" : " "
            self.inputText = self.textBeforeDictation + separator + transcript
        }
        speechService.onFinish = { [weak self] _ in
            self?.isDictating = false
            self?.speechService.deactivateSession()
        }
        speechService.onError = { [weak self] error in
            guard let self else { return }
            self.isDictating = false
            self.errorMessage = self.localizedErrorMessage(for: error)
        }
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
