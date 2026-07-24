//
//  RAGResponseDTO.swift
//  NutriScan
//

import Foundation

struct RAGResponseDTO: Decodable {
    let query: String
    let answer: String
    let sources: [RAGSourceDTO]
}

struct RAGSourceDTO: Decodable {
    let fileName: String
    let chunkIndex: Int
    let score: Double
    let snippet: String
}
