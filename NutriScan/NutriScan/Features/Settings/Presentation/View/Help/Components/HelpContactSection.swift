//
//  HelpContactSection.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 30/07/2026.
//

import SwiftUI

struct HelpContactSection: View {
    let onContactSupportClick: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: HelperSemantics.Spacing.itemSpacing) {
            Text(LocalizationKeys.Settings.contactUs.localized)
                .font(Font.AppFont.subtitle1)
                .foregroundColor(Color.HelperSemantic.sectionTitle)
            
            MenuRowView(
                icon: "envelope.fill",
                title: LocalizationKeys.Settings.contactSupport.localized,
                action: onContactSupportClick
            )
        }
    }
}
