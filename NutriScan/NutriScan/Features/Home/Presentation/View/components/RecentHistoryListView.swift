//
//  HomeRecentHistoryList.swift
//  NutriScan
//
//  Created by Youssef Abd El-Fatah on 15/07/2026.
//

import SwiftUI

struct RecentHistoryView: View {
    let historyItems: [UiStateHistoryItem]
    var onViewAll: () -> Void = {}

    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Text("Recent History")
                    .font(Font.AppFont.title3)
                    .foregroundColor(Color.HomeSemantic.historyHeaderTitle)

                Spacer()

                Button(action: onViewAll) {
                    Text("View All")
                        .font(Font.AppFont.textDefault)
                        .foregroundColor(Color.HomeSemantic.historyHeaderAction)
                }
            }

            // List
            VStack(spacing: 16) {
                ForEach(historyItems) { item in
                    HistoryRowView(item: item)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview("Light") {
    RecentHistoryView(
        historyItems: [
            UiStateHistoryItem(id: "1", title: "Orange Juice", scannedAt: "Today, 9:24 AM", imageName: "orange_juice", status: .safe),
            UiStateHistoryItem(id: "2", title: "Greek Yogurt", scannedAt: "Yesterday, 4:15 PM", imageName: "greek_yogurt", status: .caution),
            UiStateHistoryItem(id: "3", title: "Granola Bar", scannedAt: "Yesterday, 11:30 AM", imageName: "granola_bar", status: .unsafe)
        ]
    )
    .padding(20)
    .background(Color.Teal.teal100)
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    RecentHistoryView(
        historyItems: [
            UiStateHistoryItem(id: "1", title: "Orange Juice", scannedAt: "Today, 9:24 AM", imageName: "orange_juice", status: .safe),
            UiStateHistoryItem(id: "2", title: "Greek Yogurt", scannedAt: "Yesterday, 4:15 PM", imageName: "greek_yogurt", status: .caution),
            UiStateHistoryItem(id: "3", title: "Granola Bar", scannedAt: "Yesterday, 11:30 AM", imageName: "granola_bar", status: .unsafe)
        ]
    )
    .padding(20)
    .background(Color.Teal.teal1600)
    .preferredColorScheme(.dark)
}
