//
//  ProfileHeaderView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 19/07/2026.
//
import SwiftUI

struct EditProfileHeaderView: View {
    let name: String
    let email: String
    let avatarImage: Image

    var body: some View {
        HStack(spacing: EditProfileSemantics.Spacing.headerRowSpacing) {
            ZStack(alignment: .topTrailing) {
                ZStack {
                    Circle()
                        .stroke(
                            Color.EditProfileSemantics.avatarBorder,
                            lineWidth: 2
                        )
                        .frame(
                            width: EditProfileSemantics.Sizes
                                .outerAvatarDiameter,
                            height: EditProfileSemantics.Sizes
                                .outerAvatarDiameter
                        )

                    avatarImage
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: EditProfileSemantics.Sizes.avatarDiameter,
                            height: EditProfileSemantics.Sizes.avatarDiameter
                        )
                        .clipShape(Circle())
                }

                ZStack {
                    Circle()
                        .fill(Color.white)
                        .stroke(Color.white, lineWidth: 2)
                        .frame(
                            width: EditProfileSemantics.Sizes
                                .outerEditBadgeDiameter,
                            height: EditProfileSemantics.Sizes
                                .outerEditBadgeDiameter)

                    Image(systemName: "pencil")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(
                            Color.EditProfileSemantics.editBadgeIcon
                        )
                        .frame(
                            width: EditProfileSemantics.Sizes.editBadgeDiameter,
                            height: EditProfileSemantics.Sizes.editBadgeDiameter
                        )
                        .background(
                            Circle().fill(
                                Color.EditProfileSemantics.editBadgeBackground))
                }
                .offset(x: 4, y: -4)
            }

            VStack(
                alignment: .leading,
                spacing: EditProfileSemantics.Spacing.headerNameSpacing
            ) {
                Text(name)
                    .font(Font.AppFont.title2)
                    .foregroundColor(Color.EditProfileSemantics.profileName)
                Text(email)
                    .font(Font.AppFont.textSecondary)
                    .foregroundColor(Color.EditProfileSemantics.profileEmail)
            }
        }
    }
}
