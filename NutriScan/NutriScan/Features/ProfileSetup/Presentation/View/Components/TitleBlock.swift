//
//  TitleBlock.swift
//  NutriScan
//
//  Created by Osama Hosam on 17/07/2026.
//

import SwiftUI
// MARK: - 3. Title + Subtitle Block (Reusable)

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
    var titleFont: Font = .system(size: 30, weight: .bold)
    var defaultTitleColor: Color = Color.Gray.gray1600
    var subtitleColor: Color = Color.Gray.gray700
 
    var body: some View {
        VStack(spacing: 12) {
            segments
                .map { segment in
                    Text(segment.text)
                        .foregroundColor(segment.color ?? defaultTitleColor)
                }
                .reduce(Text("")) { $0 + $1 }
                .font(titleFont)
 
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(subtitleColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
    }
}
