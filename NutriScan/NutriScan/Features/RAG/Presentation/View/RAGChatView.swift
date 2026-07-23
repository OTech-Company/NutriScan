//
//  RAGChatView.swift
//  NutriScan
//

import SwiftUI

struct RAGChatView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var viewModel: RAGChatViewModel

    init(viewModel: RAGChatViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            RAGChatHeaderView {
                router.pop()
            }

            Divider()
                .background(Color.RAGSemantic.inputBorder)

            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 16) {
                        if viewModel.messages.isEmpty {
                            RAGEmptyStateView()
                                .padding(.top, 80)
                        }

                        ForEach(viewModel.messages) { message in
                            RAGMessageBubbleView(message: message)
                                .id(message.id)
                        }

                        if viewModel.isLoading {
                            RAGLoadingIndicator()
                                .id("loading")
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                }
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: viewModel.messages.count) { _, _ in
                    withAnimation {
                        if let last = viewModel.messages.last {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: viewModel.isLoading) { _, loading in
                    if loading {
                        withAnimation {
                            proxy.scrollTo("loading", anchor: .bottom)
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
                onSend: { viewModel.send() }
            )
        }
        .background(Color.RAGSemantic.chatBackground.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}
