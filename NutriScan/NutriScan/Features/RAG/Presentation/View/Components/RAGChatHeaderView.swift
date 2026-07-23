//
//  RAGChatHeaderView.swift
//  NutriScan
//

import SwiftUI

struct RAGChatHeaderView: View {
    var onBack: () -> Void
    var onVoice: () -> Void

    var body: some View {
        HStack {
            BackButton(action: onBack)

            Spacer()

            Text("Nutrition AI")
                .font(Font.AppFont.subtitle1)
                .foregroundStyle(Color.RAGSemantic.headerTitle)

            Spacer()

            Button(action: onVoice) {
                Image(systemName: "waveform.circle.fill")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(Color.RAGSemantic.sendButton)
                    .frame(width: 48, height: 48)
            }
            .accessibilityLabel("Start voice chat")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.RAGSemantic.chatBackground)
    }
}
