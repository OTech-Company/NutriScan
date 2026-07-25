//
//  RAGSource.swift
//  NutriScan
//

import Foundation

struct RAGSource: Identifiable, Equatable {
    var id: String { "\(fileName)_\(chunkIndex)" }
    let fileName: String
    let chunkIndex: Int
    let score: Double
    let snippet: String
}
