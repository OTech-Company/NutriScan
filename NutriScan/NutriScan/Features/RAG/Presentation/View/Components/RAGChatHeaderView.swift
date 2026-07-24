//
//  RAGChatHeaderView.swift
//  NutriScan
//

import SwiftUI

struct RAGChatHeaderView: View {
    let language: RAGLanguage
    var onBack: () -> Void
    var onVoice: () -> Void
    var onToggleLanguage: () -> Void

    var body: some View {
        HStack {
            BackButton(action: onBack)

            Spacer()

            Text(RAGStrings.headerTitle(language))
                .font(Font.AppFont.subtitle1)
                .foregroundStyle(Color.RAGSemantic.headerTitle)

            Spacer()

            HStack(spacing: 8) {
                Button(action: onToggleLanguage) {
                    Text(language.toggleLabel)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(Color.RAGSemantic.sendButton)
                        .frame(width: 36, height: 36)
                        .background(Color.RAGSemantic.aiBubble)
                        .clipShape(Circle())
                }
                .accessibilityLabel("Switch language")

                Button(action: onVoice) {
                    Image(systemName: "waveform.circle.fill")
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundStyle(Color.RAGSemantic.sendButton)
                        .frame(width: 40, height: 40)
                }
                .accessibilityLabel("Start voice chat")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.RAGSemantic.chatBackground)
    }
}
