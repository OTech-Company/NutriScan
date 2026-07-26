//
//  ProfileHeaderLoadingView.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 26/07/2026.
//

import SwiftUI
import Shimmer

struct ProfileHeaderLoadingView: View {
    var body: some View {
        HStack(spacing: ProfileSemantics.Spacing.headerContentSpacing) {
            Circle()
                .fill(Color.gray.opacity(ProfileSemantics.Sizes.shimmerOpacity))
                .frame(
                    width: ProfileSemantics.Sizes.avatarDiameter,
                    height: ProfileSemantics.Sizes.avatarDiameter
                )
                .shimmering()

            VStack(alignment: .leading, spacing: ProfileSemantics.Spacing.tinySpacing) {
                RoundedRectangle(cornerRadius: ProfileSemantics.Radius.shimmerSmall)
                    .fill(Color.gray.opacity(ProfileSemantics.Sizes.shimmerOpacity))
                    .frame(
                        width: ProfileSemantics.Sizes.shimmerTextWidth,
                        height: ProfileSemantics.Sizes.shimmerTextHeight
                    )
                    .shimmering()

                RoundedRectangle(cornerRadius: ProfileSemantics.Radius.shimmerMedium)
                    .fill(Color.gray.opacity(ProfileSemantics.Sizes.shimmerOpacity))
                    .frame(
                        width: ProfileSemantics.Sizes.shimmerSubtextWidth,
                        height: ProfileSemantics.Sizes.shimmerSubtextHeight
                    )
                    .shimmering()
            }
            Spacer()
        }
        .padding(.horizontal, ProfileSemantics.Spacing.horizontalPadding)
        .padding(.top, ProfileSemantics.Spacing.headerVerticalPadding)
        .padding(.bottom, ProfileSemantics.Spacing.headerVerticalPadding)
    }
}

#Preview {
    ProfileHeaderLoadingView()
        .background(Color.ProfileSemantics.headerBackground)
}
