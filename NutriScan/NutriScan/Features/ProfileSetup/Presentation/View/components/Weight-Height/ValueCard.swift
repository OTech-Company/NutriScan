//
//  ValueCard.swift
//  NutriScan
//
//  Created by Osama Hosam on 17/07/2026.
//

import SwiftUI

enum ValueCardStyle {
    case boxed
    case plain
}

struct ValueCard: View {

    let value: Int
    var style: ValueCardStyle = .plain
    var sideCount: Int = 2

    var body: some View {
        VStack(spacing: 8) {

            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 10)
                .rotationEffect(.degrees(180))
                .foregroundStyle(Color.ProfileSetupSemantic.accent)

            HStack(spacing: style == .boxed ? 16 : 18) {
                ForEach((-sideCount)...sideCount, id: \.self) { offset in
                    valueView(for: offset)
                }
            }
        }
    }

    @ViewBuilder
    private func valueView(for offset: Int) -> some View {

        let number = value + offset

        if offset == 0 {

            Text("\(number)")
                .font(Font.AppFont.title1)
                .foregroundStyle(Color.ProfileSetupSemantic.primaryText)
                .frame(
                    width: 120,
                    height: style == .boxed ? 180 : 118
                )
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.ProfileSetupSemantic.selectedCard)
                        .shadow(
                            color: Color.ProfileSetupSemantic.selectedCard.opacity(style == .plain ? 0.35 : 0.2),
                            radius: style == .plain ? 18 : 8
                        )
                )
                .customTealShadow()

        } else {

            switch style {

            case .boxed:

                Text("\(number)")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(Color.ProfileSetupSemantic.secondaryText)
                    .frame(width: 91, height: 132)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.ProfileSetupSemantic.unselectedCard)
                    )
                    .opacity(opacity(for: offset))

            case .plain:

                Text("\(number)")
                    .font(Font.AppFont.title3)
                    .foregroundStyle(Color.ProfileSetupSemantic.secondaryText)
                    .frame(width: 72)
                    .opacity(opacity(for: offset))
            }
        }
    }

    private func opacity(for offset: Int) -> Double {
        switch abs(offset) {
        case 1:
            return 1.0
        case 2:
            return 0.45
        case 3:
            return 0.2
        default:
            return 0.1
        }
    }
}

#Preview("Plain") {
    ZStack {
        Color.ProfileSetupSemantic.background
            .ignoresSafeArea()

        ValueCard(
            value: 183,
            style: .plain,
            sideCount: 2
        )
    }
}

#Preview("Boxed") {
    ZStack {
        Color.ProfileSetupSemantic.background
            .ignoresSafeArea()

        ValueCard(
            value: 72,
            style: .boxed,
            sideCount: 2
        )
    }
}
