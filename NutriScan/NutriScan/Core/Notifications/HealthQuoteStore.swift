//
//  HealthQuoteStore.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 07/08/2026.
//

import Foundation

struct HealthQuoteItem: Codable {
    let day: Int
    let quote: String
}

protocol HealthQuoteStoreProtocol {
    func quote(forDay day: Int) -> String
    func quoteForToday() -> String
}

final class HealthQuoteStore: HealthQuoteStoreProtocol {
    private var quotes: [Int: String] = [:]
    private static let fallbackQuote = "Health is a state of complete harmony of the body, mind and spirit."

    init(bundle: Bundle = .main) {
        loadQuotes(from: bundle)
    }

    private func loadQuotes(from bundle: Bundle) {
        guard let url = bundle.url(forResource: "HealthQuotes", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let items = try? JSONDecoder().decode([HealthQuoteItem].self, from: data) else {
            print("Warning: Could not load HealthQuotes.json, using fallback quote.")
            return
        }

        for item in items {
            quotes[item.day] = item.quote
        }
    }

    func quote(forDay day: Int) -> String {
        // Map any day number to 1...30 index range
        let normalizedDay = max(1, ((day - 1) % 30) + 1)
        return quotes[normalizedDay] ?? Self.fallbackQuote
    }

    func quoteForToday() -> String {
        let dayOfMonth = Calendar.current.component(.day, from: Date())
        return quote(forDay: dayOfMonth)
    }
}
