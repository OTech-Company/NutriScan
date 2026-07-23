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

    private let queryUseCase: QueryRAGUseCase

    init(queryUseCase: QueryRAGUseCase) {
        self.queryUseCase = queryUseCase
    }

    var canSend: Bool {
        !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isLoading
    }

    func send() {
        let question = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !question.isEmpty else { return }

        inputText = ""
        errorMessage = nil

        Task {
            await performQuery(question)
        }
    }

    private func performQuery(_ question: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let message = try await queryUseCase.execute(question: question)
            messages.append(message)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
