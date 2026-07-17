//
//  GenderSelectionCard.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 17/07/2026.
//
//
//  GenderSelectionCard.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 17/07/2026.
//
//
//  GenderSelectionCard.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 17/07/2026.
//
import SwiftUI

struct GenderSelectionCard: View {
    let title: String
    let image: Image
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: GenderSelectionCardConstants.internalSpacing) {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(
                        width: GenderSelectionCardConstants.imageSize,
                        height: GenderSelectionCardConstants.imageSize
                    )

                Text(title)
                    .font(
                        isSelected
                            ? Font.AppFont.title3 : Font.AppFont.subtitle2
                    )
                    .foregroundColor(
                        title == "Male"
                            ? Color.ProfileSetupSemantic.maleCardText
                            : Color.ProfileSetupSemantic.femaleCardText
                    )
            }
            .padding(
                isSelected
                    ? GenderSelectionCardConstants.selectedPaddingHorizontal : 0
            )
            .frame(
                width: isSelected
                    ? GenderSelectionCardConstants.selectedWidth
                    : GenderSelectionCardConstants.unselectedWidth,
                height: isSelected
                    ? GenderSelectionCardConstants.selectedHeight
                    : GenderSelectionCardConstants.unselectedHeight
            )
            .background(
                isSelected
                    ? Color.ProfileSetupSemantic.maleCardBackground
                    : Color.ProfileSetupSemantic.femaleCardBackground
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: GenderSelectionCardConstants.cornerRadius)
            )
            .modifier(SelectedCardShadow(isSelected: isSelected))
            .scaleEffect(
                isSelected ? GenderSelectionCardConstants.selectedScale : 1.0
            )
            .fixedSize()
            .compositingGroup()  // ensures scale applies to the rendered card as one flattened unit, not per-subview
        }
        .buttonStyle(.plain)
        .animation(
            GenderSelectionCardConstants.springAnimation, value: isSelected)
    }
}

private struct SelectedCardShadow: ViewModifier {
    let isSelected: Bool

    func body(content: Content) -> some View {
        if isSelected {
            content.customTealShadow()
        } else {
            content
        }
    }
}

#Preview("Light Mode") {
    HStack(spacing: 22) {
        GenderSelectionCard(
            title: "Female", image: Image("female"), isSelected: false,
            action: {})
        GenderSelectionCard(
            title: "Male", image: Image("male"), isSelected: true, action: {})
    }
    .padding()
    .background(Color.Teal.teal100)
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    HStack(spacing: 22) {
        GenderSelectionCard(
            title: "Female", image: Image("female"), isSelected: false,
            action: {})
        GenderSelectionCard(
            title: "Male", image: Image("male"), isSelected: true, action: {})
    }
    .padding()
    .background(Color.Teal.teal1600)
    .preferredColorScheme(.dark)
}
