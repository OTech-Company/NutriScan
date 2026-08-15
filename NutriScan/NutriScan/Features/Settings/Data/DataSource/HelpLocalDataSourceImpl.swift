//
//  HelpLocalDataSourceImpl.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 30/07/2026.
//

import Foundation

final class HelpLocalDataSourceImpl: HelpLocalDataSourceProtocol {
    
    func getFaqs() async throws -> [FaqItem] {
        // Simulating a fast local fetch delay
        try await Task.sleep(nanoseconds: 300_000_000)
        
        return [
            FaqItem(id: 1, question: LocalizationKeys.Settings.faq1Question.localized, answer: LocalizationKeys.Settings.faq1Answer.localized),
            FaqItem(id: 2, question: LocalizationKeys.Settings.faq2Question.localized, answer: LocalizationKeys.Settings.faq2Answer.localized),
            FaqItem(id: 3, question: LocalizationKeys.Settings.faq3Question.localized, answer: LocalizationKeys.Settings.faq3Answer.localized),
            FaqItem(id: 4, question: LocalizationKeys.Settings.faq4Question.localized, answer: LocalizationKeys.Settings.faq4Answer.localized),
            FaqItem(id: 5, question: LocalizationKeys.Settings.faq5Question.localized, answer: LocalizationKeys.Settings.faq5Answer.localized),
            FaqItem(id: 6, question: LocalizationKeys.Settings.faq6Question.localized, answer: LocalizationKeys.Settings.faq6Answer.localized),
            FaqItem(id: 7, question: LocalizationKeys.Settings.faq7Question.localized, answer: LocalizationKeys.Settings.faq7Answer.localized),
            FaqItem(id: 8, question: LocalizationKeys.Settings.faq8Question.localized, answer: LocalizationKeys.Settings.faq8Answer.localized),
            FaqItem(id: 9, question: LocalizationKeys.Settings.faq9Question.localized, answer: LocalizationKeys.Settings.faq9Answer.localized),
            FaqItem(id: 10, question: LocalizationKeys.Settings.faq10Question.localized, answer: LocalizationKeys.Settings.faq10Answer.localized)
        ]
    }
}
