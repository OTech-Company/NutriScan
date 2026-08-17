//
//  FaqItem.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 30/07/2026.
//

import Foundation

struct FaqItem: Identifiable, Equatable {
    let id: Int
    let question: String
    let answer: String
}

extension FaqItem {
    static var dummyItems: [FaqItem] {
        [
            FaqItem(id: -1, question: LocalizationKeys.Settings.faq1Question.localized, answer: LocalizationKeys.Settings.faq1Answer.localized),
            FaqItem(id: -2, question: LocalizationKeys.Settings.faq2Question.localized, answer: LocalizationKeys.Settings.faq2Answer.localized),
            FaqItem(id: -3, question: LocalizationKeys.Settings.faq3Question.localized, answer: LocalizationKeys.Settings.faq3Answer.localized),
            FaqItem(id: -4, question: LocalizationKeys.Settings.faq4Question.localized, answer: LocalizationKeys.Settings.faq4Answer.localized),
            FaqItem(id: -5, question: LocalizationKeys.Settings.faq5Question.localized, answer: LocalizationKeys.Settings.faq5Answer.localized)
        ]
    }
}
