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
    var onTap: (String) -> Void = { _ in }
    var onRequestDelete: (UiStateHistoryItem) -> Void = { _ in }

    var body: some View {
        VStack(spacing: 16) {
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

            VStack(spacing: 16) {
                ForEach(historyItems) { item in
                    HistoryRowView(item: item)
                        .contentShape(RoundedRectangle(cornerRadius: 22))
                        .onTapGesture {
                            onTap(item.id)
                        }
                        .onLongPressGesture {
                            onRequestDelete(item)
                        }
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: .scale(scale: 0.96).combined(with: .opacity)
                        ))
                }
            }
            .animation(.spring(response: 0.28, dampingFraction: 0.85), value: historyItems.map(\.id))
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
