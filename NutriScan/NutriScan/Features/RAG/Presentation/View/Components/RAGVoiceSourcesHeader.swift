//
//  RAGVoiceSourcesHeader.swift
//  NutriScan
//
//  Created by Osama Hosam on 24/07/2026.
//


//
//  RAGVoiceSourcesHeader.swift
//  NutriScan
//

import SwiftUI

struct RAGVoiceSourcesHeader: View {
    // Swap these for your official source logos (e.g. WHO, NFSA, MOHP) when available.
    private let symbols = ["cross.case.fill", "leaf.fill", "heart.text.square.fill"]

    var body: some View {
        VStack(spacing: 14) {
            Text("Sourced from Official Documentation")
                .font(Font.AppFont.subtitle2)
                .foregroundStyle(Color.RAGSemantic.sendButton)
                .multilineTextAlignment(.center)

            HStack(spacing: 20) {
                ForEach(symbols, id: \.self) { symbol in
                    Image(systemName: symbol)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(Color.RAGSemantic.sendButton)
                        .frame(width: 52, height: 52)
                        .background(Color.RAGSemantic.aiBubble)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 24)
    }
}