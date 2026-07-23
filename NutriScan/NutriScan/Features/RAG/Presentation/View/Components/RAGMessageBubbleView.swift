//
//  RAGMessageBubbleView.swift
//  NutriScan
//

import SwiftUI

struct RAGMessageBubbleView: View {
    let message: RAGMessage

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // User question — shown immediately, before the answer exists.
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

            // AI answer / pending / failed state
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: message.isFailed ? "exclamationmark.circle" : "sparkles")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(message.isFailed ? Color.RAGSemantic.errorText : Color.RAGSemantic.sendButton)
                    .padding(.top, message.isAwaitingAnswer ? 6 : 2)

                if let answer = message.answer {
                    Text(answer)
                        .font(Font.AppFont.textDefault)
                        .foregroundStyle(Color.RAGSemantic.aiText)
                        .fixedSize(horizontal: false, vertical: true)
                } else if message.isFailed {
                    Text("Couldn't get a response. Please try again.")
                        .font(Font.AppFont.textDefault)
                        .foregroundStyle(Color.RAGSemantic.errorText)
                } else {
                    RAGTypingDotsView()
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
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
