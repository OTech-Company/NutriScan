//
//  SettingsSegmentRow.swift
//  NutriScan
//

import SwiftUI

// MARK: - Segmented Control Row
struct SettingsSegmentRow<T: Hashable & CustomStringConvertible>: View {
    let icon: String
    let title: String
    let options: [T]
    @Binding var selected: T

    var body: some View {
        HStack(spacing: 14) {
            SettingsIconBadge(icon: icon)

            Text(title)
                .font(Font.AppFont.textPrimary)
                .foregroundColor(Color.SettingsSemantic.rowTitle)

            Spacer()

            // Custom square segment picker
            HStack(spacing: 0) {
                ForEach(options, id: \.self) { option in
                    let isSelected = option == selected
                    Text(option.description)
                        .font(Font.AppFont.textCaption)
                        .fontWeight(.light)
                        .foregroundColor(
                            isSelected
                            ? Color.SettingsSemantic.segmentSelectedText
                            : Color.SettingsSemantic.segmentUnselectedText
                        )
                        .padding(.horizontal, 8)
                        .padding(.vertical, 8)
                        .background(
                            Group {
                                if isSelected {
                                    Color.SettingsSemantic.segmentSelectedBackground
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                } else {
                                    Color.clear
                                }
                            }
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3)) { selected = option }
                        }
                }
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 4)
            .background(Color.SettingsSemantic.segmentBackground)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .background(Color.SettingsSemantic.rowBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    @Previewable @State var appearance: AppAppearance = .system
    @Previewable @State var language: AppLanguage = .english

    VStack(spacing: 12) {
        SettingsSegmentRow(
            icon: "circle.lefthalf.filled",
            title: "Appearance",
            options: AppAppearance.allCases,
            selected: $appearance
        )
        SettingsSegmentRow(
            icon: "globe",
            title: "Language",
            options: AppLanguage.allCases,
            selected: $language
        )
    }
    .padding()
    .background(Color.SettingsSemantic.screenBackground)
}
