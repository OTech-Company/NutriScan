//
//  CustomTextFieldTitle.swift
//  NutriScan
//
//  Created by albaraa alsayed on 29/01/1448 AH.
//

import SwiftUI

struct CustomTextFieldTitle: View {
    var title: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Text(title)
            .font(Font.AppFont.subtitle2)
            .foregroundStyle(colorScheme == .light ? Color.Teal.teal1000 : Color.Teal.teal600)
    }
}
