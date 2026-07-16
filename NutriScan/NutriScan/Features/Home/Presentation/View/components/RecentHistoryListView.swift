//
//  HomeRecentHistoryList.swift
//  NutriScan
//
//  Created by Youssef Abd El-Fatah on 15/07/2026.
//

import SwiftUI

struct RecentHistoryView: View {
    @Environment(\.colorScheme) var colorScheme
    
    // State array holding the UiStateHistoryItem models
    @State private var historyItems: [UiStateHistoryItem] = [
        UiStateHistoryItem(id: "123", title: "Orange Juice", scannedAt: "Today, 9:24 AM", imageName: "orange_juice", status: .safe),
        UiStateHistoryItem(id: "12", title: "Greek Yogurt", scannedAt: "Yesterday, 4:15 PM", imageName: "greek_yogurt", status: .safe),
        UiStateHistoryItem(id: "1234", title: "Granola Bar", scannedAt: "Yesterday, 11:30 AM", imageName: "granola_bar", status: .unsafe),
        UiStateHistoryItem(id: "12332", title: "Energy Drink", scannedAt: "Yesterday, 9:00 AM", imageName: "energy_drink", status: .caution)
    ]
    
    // MARK: Computed Colors for Main View
    private var backgroundColor: Color {
        colorScheme == .dark ? Color.Teal.teal1600 : .white
    }
    
    private var headerTitleColor: Color {
        colorScheme == .dark ? Color.Teal.teal1000 : Color.Teal.teal1600
    }
    
    private var headerActionColor: Color {
        colorScheme == .dark ? Color.Teal.teal400 : Color.Teal.teal1400
    }
    
    var body: some View {
        ZStack {
            // Screen Background
            backgroundColor.ignoresSafeArea()
            
            ScrollView {
                VStack() {
                    // Header Area
                    HStack {
                        Text("Recent History")
                            .font(Font.AppFont.title3)
                            .foregroundColor(headerTitleColor)
                        
                        Spacer()
                        
                        Button(action: {
                            // View All Action
                        }) {
                            Text("View All")
                                .font(Font.AppFont.textDefault)
                                .foregroundColor(headerActionColor)
                        }
                    }
                    .padding(.bottom, 16)
                    
                    // List Area bound to the UI State items
                    VStack(spacing: 16){
                        ForEach(historyItems) { item in
                            HistoryRowView(item: item)
                        }
                    }
                }
            }
        }
    }
}


// MARK: - Preview

#Preview {
    Group {
        RecentHistoryView()
            .preferredColorScheme(.dark)
    }
}
