//
//  AddMemberCardView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//
import SwiftUI

struct AddMemberCardView: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    RoundedRectangle(cornerRadius: ProfileSemantics.Sizes.addMemberIconCornerRadius)
                        .fill(Color.ProfileSemantics.addMemberIconBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: ProfileSemantics.Sizes.addMemberIconCornerRadius)
                                .stroke(Color.ProfileSemantics.addMemberIconStroke, lineWidth: 1)
                        )
                        .frame(width: ProfileSemantics.Sizes.addMemberIconSize,
                               height: ProfileSemantics.Sizes.addMemberIconSize)

                    Image(systemName: "plus")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color.ProfileSemantics.addMemberIcon)
                }

                Text("ADD MEMBER")
                    .font(Font.AppFont.textSecondary)
                    .foregroundColor(Color.ProfileSemantics.addMemberText)
                    .multilineTextAlignment(.center)
            }
            .frame(width: ProfileSemantics.Sizes.memberCardWidth,
                   height: ProfileSemantics.Sizes.memberCardHeight)
            .background(Color.ProfileSemantics.addMemberBackground)
            .clipShape(RoundedRectangle(cornerRadius: ProfileSemantics.Radius.memberCardRadius))
        }
        .buttonStyle(.plain)
    }
}
