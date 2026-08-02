//
//  SectionHeader.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title.uppercased())
            .font(Font.AppFont.textSecondary)
            .fontWeight(.medium)
            .foregroundColor(Color.NotificationSemantic.sectionLabel)
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
