//
//  TermsItem.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//

import Foundation

struct TermsItem: Identifiable, Equatable {
    let id: Int
    let title: String
    let body: String
}

extension TermsItem {
    static var dummyItems: [TermsItem] {
        [
            TermsItem(id: -1, title: LocalizationKeys.Settings.terms1Title.localized, body: LocalizationKeys.Settings.terms1Body.localized),
            TermsItem(id: -2, title: LocalizationKeys.Settings.terms2Title.localized, body: LocalizationKeys.Settings.terms2Body.localized),
            TermsItem(id: -3, title: LocalizationKeys.Settings.terms3Title.localized, body: LocalizationKeys.Settings.terms3Body.localized),
            TermsItem(id: -4, title: LocalizationKeys.Settings.terms4Title.localized, body: LocalizationKeys.Settings.terms4Body.localized),
            TermsItem(id: -5, title: LocalizationKeys.Settings.terms5Title.localized, body: LocalizationKeys.Settings.terms5Body.localized)
        ]
    }
}
