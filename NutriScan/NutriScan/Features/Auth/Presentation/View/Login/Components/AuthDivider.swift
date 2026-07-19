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
                .fill(Color.LoginSemantic.dividerLine)
                .frame(height: 1)
            Text("OR")
                .font(Font.AppFont.textCaption)
                .foregroundColor(Color.LoginSemantic.dividerLabel)
                .padding(.horizontal, 8)
            Rectangle()
                .fill(Color.LoginSemantic.dividerLine)
                .frame(height: 1)
        }
    }
}
