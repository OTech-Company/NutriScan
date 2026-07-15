//
//  AuthDivider.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 15/07/2026.
//

import SwiftUI

struct AuthDivider: View {
    var body: some View {
        HStack {
            Rectangle()
                .fill(Color.Gray.gray500)
                .frame(height: 1)
            Text("OR")
                .font(Font.AppFont.textCaption)
                .foregroundColor(Color.Gray.gray800)
                .padding(.horizontal, 12)
            Rectangle()
                .fill(Color.Gray.gray500)
                .frame(height: 1)
        }
        .padding(.horizontal, 40)
    }
}
