//
//  RAGChatView.swift
//  NutriScan
//

import SwiftUI

struct RAGChatView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: RAGChatViewModel
    @State private var showVoiceChat = false

    init(viewModel: RAGChatViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            RAGChatHeaderView(
                language: viewModel.language,
                onBack: { dismiss() },
                onVoice: { showVoiceChat = true },
                onToggleLanguage: { viewModel.toggleLanguage() }
            )

            Divider()
                .background(Color.RAGSemantic.inputBorder)

            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 16) {
                        if viewModel.messages.isEmpty {
                            RAGEmptyStateView(language: viewModel.language)
                                .padding(.top, 80)
                        }

                        ForEach(viewModel.messages) { message in
                            RAGMessageBubbleView(message: message)
                                .id(message.id)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                }
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: viewModel.messages) { _, _ in
                    withAnimation {
                        if let last = viewModel.messages.last {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }

            // Error
            if let error = viewModel.errorMessage {
                Text(error)
                    .font(Font.AppFont.textCaption)
                    .foregroundStyle(Color.RAGSemantic.errorText)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 4)
            }

            // Input
            RAGChatInputView(
                text: $viewModel.inputText,
                canSend: viewModel.canSend,
                isLoading: viewModel.isLoading,
                isDictating: viewModel.isDictating,
                language: viewModel.language,
                onSend: { viewModel.send() },
                onToggleDictation: { viewModel.toggleDictation() }
            )
        }
        .background(Color.RAGSemantic.chatBackground.ignoresSafeArea())
        .environment(\.layoutDirection, viewModel.language.layoutDirection)
        .fullScreenCover(isPresented: $showVoiceChat) {
            RAGVoiceChatView(queryUseCase: viewModel.queryUseCase, language: viewModel.language)
        }
    }
}
