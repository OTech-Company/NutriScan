//
//  HistoryRowView.swift
//  NutriScan
//
//  Created by Youssef Abd El-Fatah on 15/07/2026.
//
import SwiftUI

struct HistoryRowView: View {
    // Passing the specific UI state item down to the row
    let item: UiStateHistoryItem
    
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
                    .foregroundColor(Color.HomeSemantic.historyTitle)
                
                Text(item.scannedAt)
                    .font(Font.AppFont.textCaption)
                    .foregroundColor(Color.HomeSemantic.historySubtitle)
            }
            
            Spacer()
            
            // Status Icon & Tag
            HStack(spacing: 8) {
                if item.status == .safe {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color.HomeSemantic.tagSafeText)
                        .font(.system(size: 20))
                } else {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(item.status == .unsafe ? Color.Red.red500 : .yellow)
                        .font(.system(size: 18))
                }
                
                Text(item.status.label)
                    .font(Font.AppFont.textCaption)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(item.status.backgroundColor)
                    )
                    .foregroundColor(item.status.textColor)
            }
        }
        .frame(height: 96)
        .padding(16)
        .background(Color.HomeSemantic.historyCardBackground)
        .cornerRadius(22)
        .customTealShadow()
    }
}
