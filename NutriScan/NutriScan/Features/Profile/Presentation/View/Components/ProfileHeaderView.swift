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
            HStack(spacing: 14) {
                AsyncImage(url: avatarURL.flatMap(URL.init)) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(.white.opacity(0.6))
                }
                .frame(
                    width: ProfileSemantics.Sizes.avatarDiameter,
                    height: ProfileSemantics.Sizes.avatarDiameter
                )
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(
                        Color.ProfileSemantics.avatarBorder,
                        lineWidth: ProfileSemantics.Border.avatarBorderWidth)
                )

                VStack(alignment: .leading, spacing: 4) {
                    Text(userName)
                        .font(Font.AppFont.title4)  // SemiBold 22
                        .foregroundColor(Color.ProfileSemantics.userName)

                    Text("\(streakDays) Day streak")
                        .font(Font.AppFont.textSecondary)  // Lexend Deca Regular 14
                        .foregroundColor(Color.ProfileSemantics.streakText)
                        .padding(
                            .horizontal,
                            ProfileSemantics.Spacing.streakPaddingHorizontal
                        )
                        .padding(
                            .vertical,
                            ProfileSemantics.Spacing.streakPaddingVertical
                        )
                        .background(Color.ProfileSemantics.streakBackground)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: ProfileSemantics.Radius
                                    .streakBadge))
                }

                Spacer()

                Button(action: onEdit) {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(Color.ProfileSemantics.editIcon)
                        .frame(
                            width: ProfileSemantics.Sizes.editIconSize,
                            height: ProfileSemantics.Sizes.editIconSize)
                }
            }
            .padding(.horizontal, ProfileSemantics.Spacing.horizontalPadding)
            .padding(.top, 42)
            .padding(.bottom, 42)
        }
        .frame(height: ProfileSemantics.HeaderLayout.headerHeight).clipShape(
            RoundedCorner(radius: 0, corners: []))  // no bottom rounding on header itself
    }
}
