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
        HStack(spacing: 14) {
            Circle()
                .fill(Color.gray.opacity(0.15))
                .frame(width: 56, height: 56)
                .shimmering()

            VStack(alignment: .leading, spacing: 4) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 140, height: 22)
                    .shimmering()

                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 90, height: 20)
                    .shimmering()
            }
            Spacer()
        }
        .padding(.horizontal, ProfileSemantics.Spacing.horizontalPadding)
        .padding(.top, 42)
        .padding(.bottom, 42)
    }
}

#Preview {
    ProfileHeaderLoadingView()
        .background(Color.ProfileSemantics.headerBackground)
}
