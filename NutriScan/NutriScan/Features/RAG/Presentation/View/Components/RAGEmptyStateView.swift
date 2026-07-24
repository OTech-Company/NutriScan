//
//  RAGEmptyStateView.swift
//  NutriScan
//

import SwiftUI

struct RAGEmptyStateView: View {
    let language: RAGLanguage

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 48))
                .foregroundStyle(Color.RAGSemantic.sendButton.opacity(0.6))

            Text(RAGStrings.emptyStateTitle(language))
                .font(Font.AppFont.subtitle2)
                .foregroundStyle(Color.RAGSemantic.aiText)

            Text(RAGStrings.emptyStateSubtitle(language))
                .font(Font.AppFont.textSecondary)
                .foregroundStyle(Color.RAGSemantic.placeholder)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }
}
