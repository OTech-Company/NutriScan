//
//  HomeReadyToScanSection.swift
//  NutriScan
//

import SwiftUI

struct HomeReadyToScanSection: View {
    var onScanTap: () -> Void = {}

    var body: some View {
        Button(action: onScanTap) {
            VStack(spacing: 12) {
                Image(systemName: "barcode.viewfinder")
                    .font(.system(size: 48, weight: .light))
                    .foregroundColor(Color.HomeSemantic.scanIcon)

                Text("Ready to scan?")
                    .font(Font.AppFont.title2)
                    .foregroundColor(Color.HomeSemantic.scanTitle)

                Text("Check nutritional facts instantly")
                    .font(Font.AppFont.questrialRegular14)
                    .foregroundColor(Color.HomeSemantic.scanSubtitle)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
            .background(Color.HomeSemantic.scanCardBackground)
            .cornerRadius(22)
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [8, 5]))
                    .foregroundColor(Color.HomeSemantic.scanBorder)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview("Light") {
    HomeReadyToScanSection()
        .padding(20)
        .background(Color.Teal.teal100)
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    HomeReadyToScanSection()
        .padding(20)
        .background(Color.Teal.teal1600)
        .preferredColorScheme(.dark)
}
