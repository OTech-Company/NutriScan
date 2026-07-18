//
//  StepProgressText.swift
//  NutriScan
//
//  Created by Osama Hosam on 17/07/2026.
//

import SwiftUI

struct StepProgressText: View {

    var current: Int
    var total: Int

    var body: some View {
        HStack(spacing: 0) {
            Text("\(current)")
                .foregroundStyle(Color.ProfileSetupSemantic.stepCurrent)

            Text("/\(total)")
                .foregroundStyle(Color.ProfileSetupSemantic.stepRemaining)
        }
        .font(Font.AppFont.textSecondary)
    }
}

#Preview {
    ZStack {
        Color.ProfileSetupSemantic.background
            .ignoresSafeArea()

        StepProgressText(current: 3, total: 4)
    }
}
