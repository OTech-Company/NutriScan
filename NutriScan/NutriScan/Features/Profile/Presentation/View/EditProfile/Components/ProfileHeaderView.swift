//
//  ProfileHeaderView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 19/07/2026.
//
import SwiftUI

struct ProfileHeaderView: View {
    let name: String
    let email: String
    let avatarImage: Image

    var body: some View {
        HStack(spacing: EditProfileSemantics.Spacing.headerRowSpacing) {
            ZStack(alignment: .bottomTrailing) {
                avatarImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: EditProfileSemantics.Sizes.avatarDiameter,
                           height: EditProfileSemantics.Sizes.avatarDiameter)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.EditProfileSemantics.avatarBorder, lineWidth: 2))

                Image(systemName: "pencil")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color.EditProfileSemantics.editBadgeIcon)
                    .frame(width: EditProfileSemantics.Sizes.editBadgeDiameter,
                           height: EditProfileSemantics.Sizes.editBadgeDiameter)
                    .background(Circle().fill(Color.EditProfileSemantics.editBadgeBackground))
            }

            VStack(alignment: .leading, spacing: EditProfileSemantics.Spacing.headerNameSpacing) {
                Text(name)
                    .font(Font.AppFont.subtitle1)
                    .foregroundColor(Color.EditProfileSemantics.profileName)
                Text(email)
                    .font(Font.AppFont.textSecondary)
                    .foregroundColor(Color.EditProfileSemantics.profileEmail)
            }

            Spacer()
        }
    }
}
