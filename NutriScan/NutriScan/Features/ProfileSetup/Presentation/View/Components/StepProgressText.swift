//
//  StepProgressText.swift
//  NutriScan
//
//  Created by Osama Hosam on 17/07/2026.
//

import SwiftUI

// Progress Indicator
struct StepProgressText: View {
    var current: Int
    var total: Int
    var body: some View {
        Text("\(current)/\(total)")
            .font(.subheadline)
            .foregroundColor(Color.Teal.teal900)
    }
}
