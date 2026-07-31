//
//  TermsSectionCard.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//

import SwiftUI

struct TermsSectionCard: View {
    let item: TermsItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item.title)
                .font(Font.AppFont.subtitle1)
                .foregroundColor(Color.TermsSemantic.title)
            
            if !item.body.isEmpty {
                Text(item.body)
                    .font(Font.AppFont.textSecondary)
                    .foregroundColor(Color.TermsSemantic.body)
                    .lineSpacing(4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
