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
            // Food Image Placeholder or Loaded Image (Circle)
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
            .frame(width: 64, height: 64)
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
        .padding(.horizontal, 16)
        .frame(height: 96)
        .background(Color.HomeSemantic.historyCardBackground)
        .cornerRadius(22)
        .customLightShadow()
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
}
