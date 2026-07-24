//
//  RAGSourcesSection.swift
//  NutriScan
//

import SwiftUI

struct RAGSourcesSection: View {
    let sources: [RAGSource]
    let language: RAGLanguage

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(RAGStrings.sourcesTitle(language))
                .font(Font.AppFont.textSecondary)
                .foregroundStyle(Color.RAGSemantic.sourceFileName)
                .fontWeight(.semibold)

            ForEach(sources) { source in
                RAGSourceCardView(source: source)
            }
        }
    }
}
