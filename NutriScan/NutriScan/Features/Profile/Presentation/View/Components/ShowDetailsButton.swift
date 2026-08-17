//
//  ShowDetailsButton.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 25/07/2026.
//

import SwiftUI

struct ShowDetailsButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(LocalizationKeys.Profile.showDetails.localized)
                .font(Font.AppFont.lexendDecaLight10)
                .foregroundColor(Color.Teal.teal100)
                .frame(
                    width: ProfileSemantics.Sizes.showDetailsButtonWidth,
                    height: ProfileSemantics.Sizes.showDetailsButtonHeight
                )
                .background(Color.Teal.teal800)
                .clipShape(RoundedRectangle(cornerRadius: ProfileSemantics.Radius.showDetailsButton))
        }
    }
}
