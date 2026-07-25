//
//  FamilyMembersSectionView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

import SwiftUI
import Shimmer

struct FamilyMembersSectionView: View {
    let members: [FamilyMember]
    var isLoading: Bool = false
    var onAddMember: () -> Void
    var onShowDetails: (FamilyMember) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Family Members")
                .font(Font.AppFont.title4)
                .foregroundColor(Color.ProfileSemantics.sectionTitle)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: ProfileSemantics.Spacing.familyMembersGap) {
                    if isLoading {
                        ForEach(FamilyMember.dummyList) { member in
                            FamilyMemberCardView(
                                member: member,
                                onShowDetails: {}
                            )
                            .redacted(reason: .placeholder)
                            .shimmering()
                        }
                    } else {
                        ForEach(members) { member in
                            FamilyMemberCardView(
                                member: member,
                                onShowDetails: { onShowDetails(member) })
                        }
                        AddMemberCardView(action: onAddMember)
                    }
                }
                // Applies the padding inside the scroll view so the background encompasses it
                .padding(.leading, ProfileSemantics.Spacing.horizontalPadding)
                .padding(.trailing, ProfileSemantics.Spacing.horizontalPadding)
                .frame(height: ProfileSemantics.FamilySection.containerHeight)
                .background(
                    OpenRightRoundedRect(
                        cornerRadius: ProfileSemantics.Radius
                            .familyMembersContainerLight
                    )
                    .fill(Color.ProfileSemantics.familyMembersContainerBackground)
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
            .padding(.trailing, -ProfileSemantics.Spacing.horizontalPadding)
        }
    }
}

#Preview("Light & Dark Mode") {
    VStack(spacing: 24) {
        FamilyMembersSectionView(
            members: [
                FamilyMember(
                    id: "1",
                    name: "Sara",
                    relation: "Daughter",
                    allergies: [],
                    diseases: []
                ),
                FamilyMember(
                    id: "2",
                    name: "Omar",
                    relation: "Son",
                    allergies: [],
                    diseases: []
                )
            ],
            onAddMember: {},
            onShowDetails: { _ in }
        )
    }
    .padding()
    .background(Color.ProfileSemantics.background)
}
