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
        HStack(spacing: 14) {
            // Food Image / Icon Container
            Group {
                if let imageName = item.imageName, !imageName.isEmpty ,  imageName.starts(with: "http") {
                    CachedImage(
                        urlString: imageName,
                        failureImageName: "",
                        contentMode: .fill
                    )
                  
                } else {
                    fallbackIconView
                }
            }
            .frame(width: 56, height: 56)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.Teal.teal500.opacity(0.15), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
            
            // Text Content
            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(Font.AppFont.plusJakartaSansSemiBold16)
                    .foregroundColor(Color.HomeSemantic.historyTitle)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.system(size: 11))
                        .foregroundColor(Color.HomeSemantic.historySubtitle)
                    
                    Text(item.scannedAt)
                        .font(Font.AppFont.lexendDecaRegular12)
                        .foregroundColor(Color.HomeSemantic.historySubtitle)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            // Status Tag Badge
            HStack(spacing: 6) {
                Image(systemName: badgeIcon(for: item.status))
                    .font(.system(size: 11, weight: .bold))
                
                Text(item.status.label.replacingOccurrences(of: "\n", with: " "))
                    .font(Font.AppFont.lexendDecaMedium11)
                    .fontWeight(.bold)
                    .lineLimit(1)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(item.status.backgroundColor)
            )
            .foregroundColor(item.status.textColor)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.HomeSemantic.historyCardBackground)
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.Teal.teal500.opacity(0.12), lineWidth: 1)
        )
        .customTealShadow()
    }
    
    // MARK: - Helpers
    
    private var fallbackIconView: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.Teal.teal200.opacity(0.4),
                    Color.Teal.teal500.opacity(0.15)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            Image(systemName: fallbackIcon(for: item.status))
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(item.status.textColor)
        }
    }
    
    private func fallbackIcon(for status: StatusType) -> String {
        switch status {
        case .safe:
            return "leaf.fill"
        case .caution:
            return "hand.raised.fill"
        case .unsafe:
            return "exclamationmark.octagon.fill"
        }
    }
    
    private func badgeIcon(for status: StatusType) -> String {
        switch status {
        case .safe:
            return "checkmark.circle.fill"
        case .caution:
            return "exclamationmark.triangle.fill"
        case .unsafe:
            return "xmark.octagon.fill"
        }
    }
}
