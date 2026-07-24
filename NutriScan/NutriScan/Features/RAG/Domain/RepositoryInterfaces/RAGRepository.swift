//
//  RAGRepository.swift
//  NutriScan
//

import Foundation

protocol RAGRepository {
    func query(_ question: String, language: RAGLanguage) async throws -> RAGMessage
}
