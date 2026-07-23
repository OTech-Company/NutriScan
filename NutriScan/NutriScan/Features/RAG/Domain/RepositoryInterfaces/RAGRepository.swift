//
//  RAGRepository.swift
//  NutriScan
//

import Foundation

protocol RAGRepository {
    func query(_ question: String) async throws -> RAGMessage
}
