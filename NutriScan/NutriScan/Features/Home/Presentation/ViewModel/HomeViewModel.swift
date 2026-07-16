//
//  HomeViewModel.swift
//  NutriScan
//
//  Created by Osama Hosam on 13/07/2026.
//

import Foundation
import Observation

@Observable
final class HomeViewModel {

    // MARK: - User
    var userName: String = "Youssef"

    // MARK: - Daily Tip
    var dailyTip: String = "Stay hydrated! Drink at least 8 glasses of water today."

    // MARK: - Recent History (mock data)
    var recentHistory: [UiStateHistoryItem] = [
        UiStateHistoryItem(
            id: "1",
            title: "Orange Juice",
            scannedAt: "Today, 9:24 AM",
            imageName: "orange_juice",
            status: .safe
        ),
        UiStateHistoryItem(
            id: "2",
            title: "Greek Yogurt",
            scannedAt: "Yesterday, 4:15 PM",
            imageName: "greek_yogurt",
            status: .caution
        ),
        UiStateHistoryItem(
            id: "3",
            title: "Granola Bar",
            scannedAt: "Yesterday, 11:30 AM",
            imageName: "granola_bar",
            status: .unsafe
        )
    ]
}
