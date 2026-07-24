//
//  RAGLoadingIndicator.swift
//  NutriScan
//

import SwiftUI

struct RAGLoadingIndicator: View {
    @State private var phase = false

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "sparkles")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.RAGSemantic.sendButton)
                .padding(.top, 14)

            HStack(spacing: 5) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(Color.RAGSemantic.sendButton)
                        .frame(width: 7, height: 7)
                        .opacity(phase ? 1.0 : 0.3)
                        .animation(
                            .easeInOut(duration: 0.5)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.15),
                            value: phase
                        )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(Color.RAGSemantic.aiBubble)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            Spacer()
        }
        .onAppear {
            phase = true
        }
    }
}
