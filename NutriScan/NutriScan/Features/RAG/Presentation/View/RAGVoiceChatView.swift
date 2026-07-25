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

            Spacer(minLength: 16)

            Text(viewModel.statusLabel)
                .font(Font.AppFont.subtitle2)
                .foregroundStyle(viewModel.state == .error ? Color.RAGSemantic.errorText : Color.RAGSemantic.aiText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .animation(.easeInOut(duration: 0.2), value: viewModel.statusLabel)

            Spacer(minLength: 16)

            // Action button — different icon per state
            Button(action: { viewModel.toggleAction() }) {
                Image(systemName: actionButtonIcon)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 72, height: 72)
                    .background(actionButtonColor)
                    .clipShape(Circle())
                    .shadow(color: actionButtonColor.opacity(0.4), radius: 12, y: 4)
            }
            .accessibilityLabel(actionButtonLabel)

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

    // MARK: - Action Button Helpers

    private var actionButtonIcon: String {
        switch viewModel.state {
        case .listening:  return "stop.fill"
        case .speaking:   return "forward.fill"
        case .thinking:   return "hourglass"
        case .idle, .error: return "mic.fill"
        }
    }

    private var actionButtonColor: Color {
        switch viewModel.state {
        case .listening:  return Color.RAGSemantic.errorText
        case .speaking:   return Color.RAGSemantic.sendButton
        case .thinking:   return Color.RAGSemantic.sendButtonDisabled
        case .idle, .error: return Color.RAGSemantic.sendButton
        }
    }

    private var actionButtonLabel: String {
        switch viewModel.state {
        case .listening:  return "Stop listening"
        case .speaking:   return "Skip answer"
        case .thinking:   return "Loading"
        case .idle, .error: return "Start speaking"
        }
    }

    // MARK: - Header / Footer

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
