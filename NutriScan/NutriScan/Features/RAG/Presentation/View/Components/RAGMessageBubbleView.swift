//
//  RAGMessageBubbleView.swift
//  NutriScan
//

import SwiftUI

struct RAGMessageBubbleView: View {
    let message: RAGMessage

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // User question
            HStack {
                Spacer()
                Text(message.query)
                    .font(Font.AppFont.textDefault)
                    .foregroundStyle(Color.RAGSemantic.userText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.RAGSemantic.userBubble)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }

            // AI answer
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.RAGSemantic.sendButton)
                        .padding(.top, 2)

                    Text(message.answer)
                        .font(Font.AppFont.textDefault)
                        .foregroundStyle(Color.RAGSemantic.aiText)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(Color.RAGSemantic.aiBubble)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            // Sources
            if !message.sources.isEmpty {
                RAGSourcesSection(sources: message.sources)
                    .padding(.leading, 4)
            }
        }
    }
}
