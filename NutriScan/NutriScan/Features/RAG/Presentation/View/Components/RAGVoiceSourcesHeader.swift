//
//  RAGVoiceSourcesHeader.swift
//  NutriScan
//

import SwiftUI

struct RAGVoiceSourcesHeader: View {
    let language: RAGLanguage

    // Asset catalog image names (in Assets.xcassets)
    private let symbols = ["world-health-organization", "wezaret_elseha", "elhaya_elkawmeya"]

    var body: some View {
        VStack(spacing: 14) {
            Text(RAGStrings.sourcedFromOfficialDocumentation(language))
                .font(Font.AppFont.subtitle2)
                .foregroundStyle(Color.RAGSemantic.sendButton)
                .multilineTextAlignment(.center)

            HStack(spacing: 20) {
                ForEach(symbols, id: \.self) { symbol in
                    Image(symbol)
                        .resizable()
                        .scaledToFit()
//                        .padding(10)
                        .frame(width: 82, height: 82)
//                        .background(Color.RAGSemantic.aiBubble)
//                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 24)
    }
}
