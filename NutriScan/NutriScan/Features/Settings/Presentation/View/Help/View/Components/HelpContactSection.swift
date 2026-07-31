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
            Text("Contact Us")
                .font(Font.AppFont.subtitle1)
                .foregroundColor(Color.HelperSemantic.sectionTitle)
            
            SettingsActionRow(
                icon: "envelope.fill",
                title: "Contact Support",
                action: onContactSupportClick
            )
        }
    }
}
