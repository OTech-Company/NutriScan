//
//  RAGChatHeaderView.swift
//  NutriScan
//

import SwiftUI

struct RAGChatHeaderView: View {
    var onBack: () -> Void

    var body: some View {
        HStack {
            BackButton(action: onBack)

            Spacer()

            Text("Nutrition AI")
                .font(Font.AppFont.subtitle1)
                .foregroundStyle(Color.RAGSemantic.headerTitle)

            Spacer()

            // Placeholder to balance the back button
            Color.clear
                .frame(width: 48, height: 48)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.RAGSemantic.chatBackground)
    }
}
