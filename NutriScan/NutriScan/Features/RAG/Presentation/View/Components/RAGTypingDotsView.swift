//
//  RAGTypingDotsView.swift
//  NutriScan
//
//  Created by Osama Hosam on 24/07/2026.
//


//
//  RAGTypingDotsView.swift
//  NutriScan
//

import SwiftUI

/// Three pulsing dots shown inside a message bubble while its answer is pending.
struct RAGTypingDotsView: View {
    @State private var phase = false

    var body: some View {
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
        .padding(.vertical, 4)
        .onAppear { phase = true }
    }
}