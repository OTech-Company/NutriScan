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

    func send() {
        let question = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !question.isEmpty, !isLoading else { return }

        if isDictating {
            stopDictation()
        }

        inputText = ""
        errorMessage = nil

        // Show the user's message in the chat immediately, then fire the request.
        let pendingMessage = RAGMessage(query: question)
        messages.append(pendingMessage)

        Task {
            await performQuery(question, messageID: pendingMessage.id)
        }
    }

    private func performQuery(_ question: String, messageID: UUID) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await queryUseCase.execute(question: question)
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
        isDictating = true
        speechService.start()
    }

    private func stopDictation() {
        isDictating = false
        speechService.stop()
    }

    private func configureSpeechService() {
        speechService.onTranscriptUpdate = { [weak self] transcript in
            guard let self else { return }
            let separator = self.textBeforeDictation.isEmpty ? "" : " "
            self.inputText = self.textBeforeDictation + separator + transcript
        }
        speechService.onFinish = { [weak self] _ in
            self?.isDictating = false
        }
        speechService.onError = { [weak self] error in
            guard let self else { return }
            self.isDictating = false
            self.errorMessage = error.localizedDescription
        }
    }
}
