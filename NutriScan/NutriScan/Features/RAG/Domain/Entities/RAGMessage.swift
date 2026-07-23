//
//  RAGMessage.swift
//  NutriScan
//

import Foundation

struct RAGMessage: Identifiable, Equatable {
    let id = UUID()
    let query: String
    let answer: String
    let sources: [RAGSource]
    let timestamp: Date

    init(query: String, answer: String, sources: [RAGSource], timestamp: Date = .init()) {
        self.query = query
        self.answer = answer
        self.sources = sources
        self.timestamp = timestamp
    }
}
