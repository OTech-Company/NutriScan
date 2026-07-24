//
//  RAGChatInputView.swift
//  NutriScan
//

import SwiftUI

struct RAGChatInputView: View {
    @Binding var text: String
    let canSend: Bool
    let isLoading: Bool
    let isDictating: Bool
    let language: RAGLanguage
    let onSend: () -> Void
    let onToggleDictation: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 8) {
                TextField("", text: $text, prompt: Text(isDictating ? RAGStrings.listeningPlaceholder(language) : RAGStrings.inputPlaceholder(language))
                    .font(Font.AppFont.textDefault)
                    .foregroundStyle(Color.RAGSemantic.placeholder))
                    .font(Font.AppFont.textDefault)
                    .foregroundStyle(Color.RAGSemantic.aiText)
                    .disabled(isLoading)
                    .onSubmit {
                        if canSend { onSend() }
                    }

                Button(action: onToggleDictation) {
                    Image(systemName: isDictating ? "mic.fill" : "mic")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(isDictating ? Color.RAGSemantic.errorText : Color.RAGSemantic.sendButton)
                }
                .disabled(isLoading)
                .accessibilityLabel(isDictating ? "Stop voice input" : "Start voice input")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.RAGSemantic.inputBackground)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(isDictating ? Color.RAGSemantic.errorText : Color.RAGSemantic.inputBorder, lineWidth: 1)
            )

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
