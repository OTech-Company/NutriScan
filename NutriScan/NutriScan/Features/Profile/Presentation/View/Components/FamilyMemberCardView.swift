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
        VStack(spacing: ProfileSemantics.Spacing.smallSpacing) {
            HStack(spacing: ProfileSemantics.Spacing.tinySpacing) {

                CachedImage(
                    urlString: member.imageUrl ?? "",
                    failureImageName: "person.circle.fill",
                    contentMode: .fill
                )
                .frame(
                    width: ProfileSemantics.Sizes.familyMemberImageSize,
                    height: ProfileSemantics.Sizes.familyMemberImageSize
                )
                .foregroundColor(Color.Gray.gray400)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(
                        Color.Teal.teal1600,
                        lineWidth: ProfileSemantics.Border.avatarBorderWidth)
                )

                Text(member.name)
                    .font(Font.AppFont.textCaption)
                    .foregroundColor(Color.ProfileSemantics.memberName)
                    .lineLimit(ProfileSemantics.Sizes.singleLine)
                    .minimumScaleFactor(
                        ProfileSemantics.Sizes.minimumScaleFactor)
            }

            ShowDetailsButton(action: onShowDetails)
        }
        .padding(ProfileSemantics.Spacing.smallSpacing)
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
