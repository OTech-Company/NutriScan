//
//  FamilyMemberCardView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

import SwiftUI

struct FamilyMemberCardView: View {
    let member: FamilyMember
    var onShowDetails: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundColor(Color.Gray.gray400)
                    .frame(
                        width: ProfileSemantics.Sizes.familyMemberImageSize,
                        height: ProfileSemantics.Sizes.familyMemberImageSize
                    )
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.Teal.teal1600, lineWidth: 1)
                    )

                Text(member.name)
                    .font(Font.AppFont.textCaption)
                    .foregroundColor(Color.ProfileSemantics.memberName)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }

            ShowDetailsButton(action: onShowDetails)
        }
        .padding(8)
        .frame(
            width: ProfileSemantics.Sizes.memberCardWidth,
            height: ProfileSemantics.Sizes.memberCardHeight
        )
        .background(Color.ProfileSemantics.memberCardBackground)
        .overlay(
            RoundedRectangle(
                cornerRadius: ProfileSemantics.Radius.memberCardRadius
            )
            .stroke(
                Color.ProfileSemantics.memberCardBorder,
                lineWidth: ProfileSemantics.Border.memberCardBorderWidth)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: ProfileSemantics.Radius.memberCardRadius))
    }
}
