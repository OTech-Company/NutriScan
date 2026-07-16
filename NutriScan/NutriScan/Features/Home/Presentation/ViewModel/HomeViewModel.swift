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
            title: "Avocado Toast",
            scannedAt: "Today, 11:42 AM",
            imageName: "https://images.unsplash.com/photo-1541532713592-79a0317b6b77?w=150&auto=format&fit=crop&q=60",
            status: .safe
        ),
        UiStateHistoryItem(
            id: "2",
            title: "Orange Juice",
            scannedAt: "Today, 9:24 AM",
            imageName: "orange_juice",
            status: .safe
        ),
        UiStateHistoryItem(
            id: "3",
            title: "Double Cheeseburger",
            scannedAt: "Yesterday, 8:10 PM",
            imageName: "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=150&auto=format&fit=crop&q=60",
            status: .unsafe
        ),
        UiStateHistoryItem(
            id: "4",
            title: "Greek Yogurt",
            scannedAt: "Yesterday, 4:15 PM",
            imageName: nil,
            status: .caution
        ),
        UiStateHistoryItem(
            id: "5",
            title: "Granola Bar",
            scannedAt: "Yesterday, 11:30 AM",
            imageName: "granola_bar",
            status: .unsafe
        ),
        UiStateHistoryItem(
            id: "6",
            title: "Organic Salad",
            scannedAt: "2 days ago, 1:15 PM",
            imageName: "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=150&auto=format&fit=crop&q=60",
            status: .safe
        ),
        UiStateHistoryItem(
            id: "7",
            title: "Diet Cola",
            scannedAt: "3 days ago, 6:05 PM",
            imageName: "",
            status: .caution
        ),
        UiStateHistoryItem(
            id: "8",
            title: "Strawberry Smoothie",
            scannedAt: "4 days ago, 10:20 AM",
            imageName: "https://images.unsplash.com/photo-1553530979-7ee52a2670c4?w=150&auto=format&fit=crop&q=60",
            status: .safe
        ),
        UiStateHistoryItem(
            id: "9",
            title: "Glazed Donut",
            scannedAt: "5 days ago, 3:45 PM",
            imageName: nil,
            status: .unsafe
        ),
        UiStateHistoryItem(
            id: "10",
            title: "Peanut Butter",
            scannedAt: "6 days ago, 9:10 AM",
            imageName: "https://images.unsplash.com/photo-1590080875515-8a3a8dc5735e?w=150&auto=format&fit=crop&q=60",
            status: .safe
        )
    ]
}
