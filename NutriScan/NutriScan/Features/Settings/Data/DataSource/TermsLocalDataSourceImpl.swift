//
//  TermsLocalDataSourceImpl.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//

import Foundation

final class TermsLocalDataSourceImpl: TermsLocalDataSourceProtocol {
    
    func getTerms() async throws -> [TermsItem] {
        // Simulate fast local fetch delay
        try await Task.sleep(nanoseconds: 300_000_000)
        
        return [
            TermsItem(
                id: 1,
                title: LocalizationKeys.Settings.terms1Title.localized,
                body: LocalizationKeys.Settings.terms1Body.localized
            ),
            TermsItem(
                id: 2,
                title: LocalizationKeys.Settings.terms2Title.localized,
                body: LocalizationKeys.Settings.terms2Body.localized
            ),
            TermsItem(
                id: 3,
                title: LocalizationKeys.Settings.terms3Title.localized,
                body: LocalizationKeys.Settings.terms3Body.localized
            ),
            TermsItem(
                id: 4,
                title: LocalizationKeys.Settings.terms4Title.localized,
                body: LocalizationKeys.Settings.terms4Body.localized
            ),
            TermsItem(
                id: 5,
                title: LocalizationKeys.Settings.terms5Title.localized,
                body: LocalizationKeys.Settings.terms5Body.localized
            ),
            TermsItem(
                id: 6,
                title: LocalizationKeys.Settings.terms6Title.localized,
                body: LocalizationKeys.Settings.terms6Body.localized
            ),
            TermsItem(
                id: 7,
                title: LocalizationKeys.Settings.terms7Title.localized,
                body: LocalizationKeys.Settings.terms7Body.localized
            ),
            TermsItem(
                id: 8,
                title: LocalizationKeys.Settings.terms8Title.localized,
                body: LocalizationKeys.Settings.terms8Body.localized
            )
        ]
    }
}
