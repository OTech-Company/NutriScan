//
//  ExerciseInstructionSteps.swift
//  NutriScan
//

import Foundation

struct ExerciseInstructionSteps: Hashable, Equatable {
    let en: [String]
    let ar: [String]

    var localizedSteps: [String] {
        let isArabic = Locale.current.language.languageCode?.identifier == "ar"
        if isArabic && !ar.isEmpty {
            return ar
        }
        return !en.isEmpty ? en : ar
    }
}
