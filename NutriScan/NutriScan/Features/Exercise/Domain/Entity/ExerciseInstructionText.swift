//
//  ExerciseInstructionText.swift
//  NutriScan
//

import Foundation

struct ExerciseInstructionText: Hashable, Equatable {
    let en: String
    let ar: String

    var localizedText: String {
        let isArabic = Locale.current.language.languageCode?.identifier == "ar"
        if isArabic && !ar.isEmpty {
            return ar
        }
        return !en.isEmpty ? en : ar
    }
}
