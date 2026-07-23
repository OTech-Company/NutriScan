//
//  RAGChatInputView.swift
//  NutriScan
//

import SwiftUI

struct RAGChatInputView: View {
    @Binding var text: String
    let canSend: Bool
    let isLoading: Bool
    let onSend: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            TextField("", text: $text, prompt: Text("Ask about nutrition...")
                .font(Font.AppFont.textDefault)
                .foregroundStyle(Color.RAGSemantic.placeholder))
                .font(Font.AppFont.textDefault)
                .foregroundStyle(Color.RAGSemantic.aiText)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color.RAGSemantic.inputBackground)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color.RAGSemantic.inputBorder, lineWidth: 1)
                )
                .disabled(isLoading)
                .onSubmit {
                    if canSend { onSend() }
                }

            Button(action: onSend) {
                Group {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "arrow.up")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
                .frame(width: 48, height: 48)
                .background(canSend ? Color.RAGSemantic.sendButton : Color.RAGSemantic.sendButtonDisabled)
                .clipShape(Circle())
            }
            .disabled(!canSend)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.RAGSemantic.inputBarBackground)
    }
}
