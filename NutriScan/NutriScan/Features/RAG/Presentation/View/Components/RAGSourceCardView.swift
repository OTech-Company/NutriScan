//
//  RAGSourceCardView.swift
//  NutriScan
//

import SwiftUI

struct RAGSourceCardView: View {
    let source: RAGSource

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "doc.text")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.RAGSemantic.sourceFileName)

                Text(source.fileName)
                    .font(Font.AppFont.textCaption)
                    .foregroundStyle(Color.RAGSemantic.sourceFileName)
                    .lineLimit(1)

                Spacer()

                Text(String(format: "%.0f%%", source.score * 100))
                    .font(Font.AppFont.textCaption)
                    .foregroundStyle(Color.RAGSemantic.sourceScore)
                    .fontWeight(.medium)
            }

            Text(source.snippet)
                .font(Font.AppFont.textCaption)
                .foregroundStyle(Color.RAGSemantic.sourceSnippet)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .background(Color.RAGSemantic.sourceCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}
