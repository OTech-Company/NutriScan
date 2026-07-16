//
//  HistoryRowView.swift
//  NutriScan
//
//  Created by Youssef Abd El-Fatah on 15/07/2026.
//
import SwiftUI

struct HistoryRowView: View {
    @Environment(\.colorScheme) var colorScheme
    
    // Passing the specific UI state item down to the row
    let item: UiStateHistoryItem
    
    // MARK: Computed Colors for Row
    private var cardBackgroundColor: Color {
        colorScheme == .dark ? Color.Teal.teal1400 : .white
    }
    
    private var titleColor: Color {
        colorScheme == .dark ? Color.Teal.teal100 : Color.Teal.teal1600
    }
    
    private var subtitleColor: Color {
        colorScheme == .dark ? Color.Teal.teal400 : Color.Gray.gray700
    }
    
    private var iconColor: Color {
        colorScheme == .dark ? Color.Teal.teal800 : Color.Teal.teal800
    }
    
    // Dynamic tag backgrounds
    private func tagBackgroundColor(for status: StatusType) -> Color {
        switch status {
        case .safe:
            return colorScheme == .dark ? Color.Teal.teal1300 : Color.Teal.teal200
        case .caution:
            return Color.yellow.opacity(0.1)
        case .unsafe:
            return Color.Red.red100
        }
    }
    
    private func tagTextColor(for status: StatusType) -> Color {
        switch status {
        case .safe:
            return colorScheme == .dark ? Color.Teal.teal400 : Color.Teal.teal800
        case .caution:
            return Color.yellow
        case .unsafe:
            return Color.Red.red500
        }
    }
    
    var body: some View {
        HStack(spacing: 8) {
            // Food Image Placeholder
            Circle()
                .fill(Color.Gray.gray300)
                .frame(width: 64, height: 64)
                .overlay(
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                )
                .clipShape(Circle())
            
            // Text Content
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(Font.AppFont.subtitle2)
                    .foregroundColor(titleColor)
                
                Text(item.scannedAt)
                    .font(Font.AppFont.textCaption)
                    .foregroundColor(subtitleColor)
            }
            
            Spacer()
            
            // Status Icon & Tag
            HStack(spacing: 8) {
                if item.status == .safe {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(iconColor)
                        .font(.system(size: 20))
                } else {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(item.status == .unsafe ? Color.Red.red500 : .yellow)
                        .font(.system(size: 18))
                }
                
                Text(item.status.label)
                    .font(Font.AppFont.textCaption)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(tagBackgroundColor(for: item.status))
                    )
                    .foregroundColor(tagTextColor(for: item.status))
            }
        }
        .frame(height: 96)
        .padding(16)
        .background(cardBackgroundColor)
        .cornerRadius(22)
        .customTealShadow()
    }
}
