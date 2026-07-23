//
//  RAGMessage.swift
//  NutriScan
//

import Foundation

struct RAGMessage: Identifiable, Equatable {
    let id: UUID
    let query: String
    var answer: String?
    var sources: [RAGSource]
    let timestamp: Date
    var isFailed: Bool

    init(
        id: UUID = UUID(),
        query: String,
        answer: String? = nil,
        sources: [RAGSource] = [],
        timestamp: Date = .init(),
        isFailed: Bool = false
    ) {
        self.id = id
        self.query = query
        self.answer = answer
        self.sources = sources
        self.timestamp = timestamp
        self.isFailed = isFailed
    }

    /// True while the user's question has been shown but the answer hasn't arrived yet.
    var isAwaitingAnswer: Bool {
        answer == nil && !isFailed
    }
}
