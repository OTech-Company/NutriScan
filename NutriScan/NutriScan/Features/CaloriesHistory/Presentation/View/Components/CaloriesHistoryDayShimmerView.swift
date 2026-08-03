//
//  CaloriesHistoryDayShimmerView.swift
//  NutriScan
//

import Shimmer
import SwiftUI

struct CaloriesHistoryDayShimmerView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack(alignment: .top) {
            HStack(spacing: 6) {
                ForEach(0..<4, id: \.self) { _ in
                    metricPlaceholder
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 20)
            .padding(.bottom, 12)
            .frame(maxWidth: .infinity)
            .frame(height: 105)
            .background(Color.CaloriesHistorySemantic.dayBackground)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .offset(y: 14)

            Capsule()
                .fill(Color.CaloriesHistorySemantic.shimmerPlaceholder)
                .frame(width: 88, height: 24)
                .customLightShadow()
        }
        .frame(height: 121)
        .redacted(reason: .placeholder)
        .shimmering(active: !reduceMotion)
        .accessibilityHidden(true)
    }

    private var metricPlaceholder: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack(spacing: 4) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.CaloriesHistorySemantic.shimmerPlaceholder)
                    .frame(width: 16, height: 16)

                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.CaloriesHistorySemantic.shimmerPlaceholder)
                    .frame(height: 8)
            }

            Spacer(minLength: 0)

            RoundedRectangle(cornerRadius: 3)
                .fill(Color.CaloriesHistorySemantic.shimmerPlaceholder)
                .frame(width: 42, height: 9)

            RoundedRectangle(cornerRadius: 3)
                .fill(Color.CaloriesHistorySemantic.shimmerPlaceholder)
                .frame(width: 30, height: 7)
        }
        .padding(6)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 72)
        .background(Color.CaloriesHistorySemantic.metricBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .customLightShadow()
    }
}

#Preview("Light") {
    CaloriesHistoryDayShimmerView()
        .padding(.horizontal, 22)
        .background(Color.CaloriesHistorySemantic.background)
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    CaloriesHistoryDayShimmerView()
        .padding(.horizontal, 22)
        .background(Color.CaloriesHistorySemantic.background)
        .preferredColorScheme(.dark)
}
