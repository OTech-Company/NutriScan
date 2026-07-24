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

    private var isDashed: Bool { members.isEmpty }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Family Members")
                .font(Font.AppFont.title4)
                .foregroundColor(Color.ProfileSemantics.sectionTitle)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: ProfileSemantics.Spacing.familyMembersGap) {
                    ForEach(members) { member in
                        FamilyMemberCardView(member: member, onShowDetails: { onShowDetails(member) })
                    }
                    AddMemberCardView(action: onAddMember)
                }
                .padding(ProfileSemantics.Spacing.horizontalPadding)
            }
            .frame(height: ProfileSemantics.FamilySection.containerHeight)
            .background(Color.ProfileSemantics.containerBackground)
            .overlay(
                RoundedRectangle(cornerRadius: ProfileSemantics.Radius.familyMembersContainerLight)
                    .strokeBorder(
                        isDashed ? Color.ProfileSemantics.dashedBorder : .clear,
                        style: StrokeStyle(
                            lineWidth: ProfileSemantics.Border.dashedWidthLight,
                            dash: ProfileSemantics.Border.dashPattern
                        )
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: ProfileSemantics.Radius.familyMembersContainerLight))
        }
    }
}
