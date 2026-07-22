//
//  FeedStateViews.swift
//  NewsFeed (Feature)
//

import SwiftUI

struct FeedEmptyStateView: View {
    var title: String = "No articles found"
    var message: String = "Try a different search term or check back later."

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(NewsFeedPalette.accentSoft)
                    .frame(width: 72, height: 72)
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 26))
                    .foregroundStyle(NewsFeedPalette.accent)
            }
            Text(title)
                .font(NewsFeedTypography.emptyStateTitle)
                .foregroundStyle(NewsFeedPalette.textPrimary)
            Text(message)
                .font(NewsFeedTypography.cardBody)
                .foregroundStyle(NewsFeedPalette.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }
}

struct FeedErrorStateView: View {
    let message: String
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(NewsFeedPalette.errorSoft)
                    .frame(width: 72, height: 72)
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 26))
                    .foregroundStyle(NewsFeedPalette.error)
            }
            Text("Something went wrong")
                .font(NewsFeedTypography.emptyStateTitle)
                .foregroundStyle(NewsFeedPalette.textPrimary)
            Text(message)
                .font(NewsFeedTypography.cardBody)
                .foregroundStyle(NewsFeedPalette.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Button(action: retryAction) {
                Text("Try Again")
                    .font(NewsFeedTypography.button)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 22)
                    .padding(.vertical, 10)
                    .background(Capsule().fill(NewsFeedPalette.accent))
            }
            .buttonStyle(.plain)
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }
}

#Preview {
    VStack(spacing: 40) {
        FeedEmptyStateView()
        FeedErrorStateView(message: "The server responded with an error (code 429).", retryAction: {})
    }
    .background(NewsFeedPalette.background)
}
