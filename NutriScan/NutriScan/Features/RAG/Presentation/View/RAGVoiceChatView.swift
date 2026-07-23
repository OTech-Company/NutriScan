//
//  RAGVoiceChatView.swift
//  NutriScan
//
//  Created by Osama Hosam on 24/07/2026.
//


import SwiftUI

struct RAGVoiceChatView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: RAGVoiceChatViewModel

    init(queryUseCase: QueryRAGUseCase) {
        _viewModel = State(initialValue: RAGVoiceChatViewModel(queryUseCase: queryUseCase))
    }

    var body: some View {
        VStack(spacing: 0) {
            RAGVoiceSourcesHeader()
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

            transcriptCard
                .padding(.horizontal, 24)

            if let error = viewModel.errorMessage, viewModel.state == .error {
                Text(error)
                    .font(Font.AppFont.textCaption)
                    .foregroundStyle(Color.RAGSemantic.errorText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
            }

            Spacer(minLength: 24)

            switchToTextButton
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
        }
        .background(Color.RAGSemantic.chatBackground.ignoresSafeArea())
        .overlay(alignment: .topLeading) {
            BackButton(action: {
                viewModel.stop()
                dismiss()
            })
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .onAppear { viewModel.start() }
        .onDisappear { viewModel.stop() }
    }

    private var transcriptCard: some View {
        Text(viewModel.displayedText)
            .font(Font.AppFont.subtitle2)
            .foregroundStyle(Color.RAGSemantic.aiText)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background(Color.RAGSemantic.aiBubble)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.RAGSemantic.inputBorder, lineWidth: 1)
            )
            .animation(.easeInOut(duration: 0.2), value: viewModel.displayedText)
    }

    private var switchToTextButton: some View {
        Button {
            viewModel.stop()
            dismiss()
        } label: {
            Text("Switch to Text Chat")
                .font(Font.AppFont.subtitle2)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.RAGSemantic.sendButton)
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        }
    }
}
