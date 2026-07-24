//
//  ProfileHeaderView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

import SwiftUI

struct ProfileHeaderView: View {
    let userName: String
    let avatarURL: String?
    let streakDays: Int
    var onEdit: () -> Void

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.ProfileSemantics.headerBackground

            ProfileHeaderDecoration()

            HStack(spacing: 12) {
                AsyncImage(url: avatarURL.flatMap(URL.init)) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(.white.opacity(0.6))
                }
                .frame(width: ProfileSemantics.Sizes.avatarDiameter,
                       height: ProfileSemantics.Sizes.avatarDiameter)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.ProfileSemantics.avatarBorder, lineWidth: ProfileSemantics.Border.avatarBorderWidth)
                )

                VStack(alignment: .leading, spacing: 6) {
                    Text(userName)
                        .font(Font.AppFont.title4) // SemiBold 22
                        .foregroundColor(Color.ProfileSemantics.userName)

                    Text("\(streakDays) Day streak")
                        .font(Font.AppFont.textSecondary) // Lexend Deca Regular 14
                        .foregroundColor(Color.ProfileSemantics.streakText)
                        .padding(.horizontal, ProfileSemantics.Spacing.streakPaddingHorizontal)
                        .padding(.vertical, ProfileSemantics.Spacing.streakPaddingVertical)
                        .background(Color.ProfileSemantics.streakBackground)
                        .clipShape(RoundedRectangle(cornerRadius: ProfileSemantics.Radius.streakBadge))
                }

                Spacer()

                Button(action: onEdit) {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color.ProfileSemantics.editIcon)
                        .frame(width: ProfileSemantics.Sizes.editIconSize,
                               height: ProfileSemantics.Sizes.editIconSize)
                }
            }
            .padding(.horizontal, ProfileSemantics.Spacing.horizontalPadding)
            .padding(.top, 60) // safe area clearance
            .padding(.bottom, 24)
        }
        .frame(height: 140)
        .clipShape(RoundedCorner(radius: 0, corners: [])) // no bottom rounding on header itself
    }
}

