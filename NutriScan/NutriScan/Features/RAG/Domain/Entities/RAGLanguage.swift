//
//  RAGLanguage.swift
//  NutriScan
//
//  Created by Osama Hosam on 24/07/2026.
//

import Foundation

/// The two languages the RAG assistant fully supports, for both typing/speaking
/// the question and receiving the answer.
enum RAGLanguage: String, CaseIterable, Identifiable, Equatable {
    case english = "en"
    case arabic = "ar"

    var id: String { rawValue }

    /// Locale identifier used for on-device speech recognition and synthesis.
    var speechLocaleIdentifier: String {
        switch self {
        case .english: return "en-US"
        case .arabic: return "ar-SA"
        }
    }

    var toggleLabel: String {
        switch self {
        case .english: return "EN"
        case .arabic: return "AR"
        }
    }

    var next: RAGLanguage {
        self == .english ? .arabic : .english
    }

    static var deviceDefault: RAGLanguage {
        let code = Locale.current.language.languageCode?.identifier ?? "en"
        return code.hasPrefix("ar") ? .arabic : .english
    }

    /// Detects whether `text` is (mostly) Arabic script and returns the matching
    /// language. Used so a typed or spoken question is routed and answered in
    /// whichever language the user actually used, independent of any UI toggle.
    static func detect(from text: String) -> RAGLanguage {
        let hasArabicScript = text.unicodeScalars.contains { scalar in
            (0x0600...0x06FF).contains(scalar.value) ||
            (0x0750...0x077F).contains(scalar.value) ||
            (0x08A0...0x08FF).contains(scalar.value) ||
            (0xFB50...0xFDFF).contains(scalar.value) ||
            (0xFE70...0xFEFF).contains(scalar.value)
        }
        return hasArabicScript ? .arabic : .english
    }
}
