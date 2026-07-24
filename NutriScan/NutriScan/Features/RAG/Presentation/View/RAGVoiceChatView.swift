//
//  RAGVoiceChatView.swift
//  NutriScan
//

import SwiftUI

struct RAGVoiceChatView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: RAGVoiceChatViewModel

    init(queryUseCase: QueryRAGUseCase, language: RAGLanguage = .deviceDefault) {
        _viewModel = State(initialValue: RAGVoiceChatViewModel(queryUseCase: queryUseCase, language: language))
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            RAGVoiceSourcesHeader(language: viewModel.language)
                .padding(.top, 12)

            Spacer(minLength: 24)

            RAGVoiceWaveformView(state: viewModel.state)
                .frame(height: 150)
                .padding(.horizontal, 24)
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.toggleListening()
                }

            Spacer(minLength: 24)

            // Only a short status word is ever shown here — never the user's
            // spoken question or the assistant's answer. The answer is spoken aloud.
            Text(viewModel.statusLabel)
                .font(Font.AppFont.subtitle2)
                .foregroundStyle(viewModel.state == .error ? Color.RAGSemantic.errorText : Color.RAGSemantic.aiText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .animation(.easeInOut(duration: 0.2), value: viewModel.statusLabel)

            Spacer(minLength: 24)

            switchToTextButton
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
        }
        .background(Color.RAGSemantic.chatBackground.ignoresSafeArea())
        .environment(\.layoutDirection, viewModel.language.layoutDirection)
        .onAppear { viewModel.start() }
        .onDisappear { viewModel.stop() }
    }

    private var header: some View {
        HStack {
            BackButton(action: {
                viewModel.stop()
                dismiss()
            })

            Spacer()

            Button(action: { viewModel.toggleLanguage() }) {
                Text(viewModel.language.toggleLabel)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Color.RAGSemantic.sendButton)
                    .frame(width: 36, height: 36)
                    .background(Color.RAGSemantic.aiBubble)
                    .clipShape(Circle())
            }
            .accessibilityLabel("Switch language")
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    private var switchToTextButton: some View {
        Button {
            viewModel.stop()
            dismiss()
        } label: {
            Text(RAGStrings.switchToTextChat(viewModel.language))
                .font(Font.AppFont.subtitle2)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.RAGSemantic.sendButton)
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        }
    }
}
