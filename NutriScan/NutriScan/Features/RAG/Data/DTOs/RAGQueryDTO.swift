//
//  RAGQueryDTO.swift
//  NutriScan
//

import Foundation

struct RAGQueryDTO: Encodable {
    let query: String
    /// ISO-639-1 code sent to the backend: "en" or "ar".
    let language: String
}
