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
    static let dummyItems: [TermsItem] = [
        TermsItem(id: -1, title: "Acceptance of Terms", body: "By creating an account and using NutriScan, you agree to these Terms and Conditions. If you don't agree, please don't use the app."),
        TermsItem(id: -2, title: "Use of the App", body: "NutriScan is provided for personal nutrition tracking. You agree to use it only for lawful purposes and to keep your account credentials secure."),
        TermsItem(id: -3, title: "Not Medical Advice", body: "Nutrition information, calorie estimates, and NutriGPT responses are for informational purposes only and are not a substitute for professional medical or dietary advice."),
        TermsItem(id: -4, title: "Scanning and Camera Data", body: "Photos taken for barcode or receipt scanning are processed to extract nutrition data and are not shared with third parties beyond what's required to provide this feature."),
        TermsItem(id: -5, title: "AI Assistant (NutriGPT)", body: "Responses from NutriGPT are generated automatically and may occasionally be inaccurate. Use your judgment before acting on AI-provided suggestions.")
    ]
}
