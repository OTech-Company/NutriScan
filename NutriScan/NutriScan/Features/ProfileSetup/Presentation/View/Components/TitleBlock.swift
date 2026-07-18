//
//  TitleBlock.swift
//  NutriScan
//
//  Created by Osama Hosam on 17/07/2026.
//

import SwiftUI

struct TitleSegment {
    let text: String
    let color: Color?

    init(_ text: String, color: Color? = nil) {
        self.text = text
        self.color = color
    }
}

struct TitleBlock: View {

    var segments: [TitleSegment]
    var subtitle: String

    var titleFont: Font = Font.AppFont.title2
    var descriptionFont: Font = Font.AppFont.textDefault
    
    var defaultTitleColor: Color = Color.ProfileSetupSemantic.title
    var subtitleColor: Color = Color.ProfileSetupSemantic.subtitle

    var body: some View {
        VStack(spacing: 12) {

            segments
                .map {
                    Text($0.text)
                        .foregroundColor($0.color ?? defaultTitleColor)
                }
                .reduce(Text(""), +)
                .font(titleFont)

            Text(subtitle)
                .font(descriptionFont)
                .foregroundColor(subtitleColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
    }
}

#Preview {
    ZStack {
        Color.ProfileSetupSemantic.background
            .ignoresSafeArea()

        TitleBlock(
            segments: [
                TitleSegment("How "),
                TitleSegment("tall ", color: Color.ProfileSetupSemantic.accent),
                TitleSegment("are you?")
            ],
            subtitle: "We'll use your height to personalize your nutrition insights and calorie calculations."
        )
    }
}
