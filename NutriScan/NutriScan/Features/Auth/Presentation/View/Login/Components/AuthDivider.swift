//
//  AuthDivider.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 15/07/2026.
//

import SwiftUI

struct AuthDivider: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack {
            Rectangle()
                .fill(Color.Gray.gray800)
                .frame(height: 1)
            Text("OR")
                .font(Font.AppFont.textCaption)
                .foregroundColor(
                    colorScheme == .light
                        ? Color.Teal.teal1600 : Color.Teal.teal500
                )
                .padding(.horizontal, 8)
            Rectangle()
                .fill(Color.Gray.gray800)
                .frame(height: 1)
        }
        .padding(.horizontal, 22)
    }
}
