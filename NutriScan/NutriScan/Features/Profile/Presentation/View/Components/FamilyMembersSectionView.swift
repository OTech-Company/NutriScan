//
//  FamilyMembersSectionView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

import SwiftUI

// MARK: - Custom Shape
/// A custom rounded rectangle that explicitly omits the right vertical edge,
/// creating an open-ended container effect.
struct OpenRightRoundedRect: Shape {
    var cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let minX = rect.minX
        let maxX = rect.maxX
        let minY = rect.minY
        let maxY = rect.maxY
        let r = cornerRadius
        
        // Start at top right
        path.move(to: CGPoint(x: maxX, y: minY))
        
        // Top edge
        path.addLine(to: CGPoint(x: minX + r, y: minY))
        
        // Top-left corner
        path.addArc(
            center: CGPoint(x: minX + r, y: minY + r),
            radius: r,
            startAngle: .degrees(-90),
            endAngle: .degrees(180),
            clockwise: true
        )
        
        // Left edge
        path.addLine(to: CGPoint(x: minX, y: maxY - r))
        
        // Bottom-left corner
        path.addArc(
            center: CGPoint(x: minX + r, y: maxY - r),
            radius: r,
            startAngle: .degrees(180),
            endAngle: .degrees(90),
            clockwise: true
        )
        
        // Bottom edge
        path.addLine(to: CGPoint(x: maxX, y: maxY))
        
        return path
    }
}

// MARK: - View
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
                        FamilyMemberCardView(member: member, onShowDetails: { onShowDetails(member) })
                    }
                    AddMemberCardView(action: onAddMember)
                }
                // Moved padding, frame, and styles to the HStack so they scroll WITH the content
                .padding(.horizontal, ProfileSemantics.Spacing.horizontalPadding)
                .frame(height: ProfileSemantics.FamilySection.containerHeight)
                .background(
                    OpenRightRoundedRect(cornerRadius: ProfileSemantics.Radius.familyMembersContainerLight)
                        .fill(Color.ProfileSemantics.containerBackground)
                )
                .overlay(
                    OpenRightRoundedRect(cornerRadius: ProfileSemantics.Radius.familyMembersContainerLight)
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
