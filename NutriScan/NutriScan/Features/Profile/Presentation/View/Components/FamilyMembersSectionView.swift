//
//  FamilyMembersSectionView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

import SwiftUI

struct FamilyMembersSectionView: View {
    let members: [FamilyMember]
    var onAddMember: () -> Void
    var onShowDetails: (FamilyMember) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Family Members")
                .font(Font.AppFont.title4)
                .foregroundColor(Color.ProfileSemantics.sectionTitle)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: ProfileSemantics.Spacing.familyMembersGap) {
                    ForEach(members) { member in
                        FamilyMemberCardView(
                            member: member,
                            onShowDetails: { onShowDetails(member) })
                    }
                    AddMemberCardView(action: onAddMember)
                }
                // Applies the padding inside the scroll view so the background encompasses it
                .padding(
                    .horizontal, ProfileSemantics.Spacing.horizontalPadding
                )
                .frame(height: ProfileSemantics.FamilySection.containerHeight)
                .background(
                    OpenRightRoundedRect(
                        cornerRadius: ProfileSemantics.Radius
                            .familyMembersContainerLight
                    )
                    .fill(Color.ProfileSemantics.containerBackground)
                )
                .overlay(
                    OpenRightRoundedRect(
                        cornerRadius: ProfileSemantics.Radius
                            .familyMembersContainerLight
                    )
                    .stroke(
                        Color.ProfileSemantics.dashedBorder,
                        style: StrokeStyle(
                            lineWidth: ProfileSemantics.Border.dashedWidthLight,
                            dash: ProfileSemantics.Border.dashPattern
                        )
                    )
                )
            }
        }
    }
}
