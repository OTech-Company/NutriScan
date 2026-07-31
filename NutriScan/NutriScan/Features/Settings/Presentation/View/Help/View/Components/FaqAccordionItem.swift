//
//  FaqAccordionItem.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 30/07/2026.
//

import SwiftUI

struct FaqAccordionItem: View {
    let item: FaqItem
    let isExpanded: Bool
    let onClick: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(.snappy(duration: 0.3)) {
                    onClick()
                }
            }) {
                HStack {
                    Text(item.question)
                        .font(Font.AppFont.textPrimary)
                        .foregroundColor(Color.HelperSemantic.questionText)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(Color.HelperSemantic.iconTint)
                }
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                Text(item.answer)
                    .font(Font.AppFont.textSecondary)
                    .foregroundColor(Color.HelperSemantic.answerText)
                    .padding(.top, 12)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(HelperSemantics.Spacing.accordionPadding)
        .background(Color.HelperSemantic.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: HelperSemantics.Sizes.accordionCornerRadius))
    }
}
