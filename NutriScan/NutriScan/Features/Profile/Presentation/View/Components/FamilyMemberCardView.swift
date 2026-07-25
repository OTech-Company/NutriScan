//
//  FamilyMemberCardView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

import SwiftUI

struct FamilyMemberCardView: View {
    let member: FamilyMember
    var onShowDetails: () -> Void

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .foregroundColor(Color.Gray.gray400)
                .frame(width: 36, height: 36)
                .clipShape(Circle())

            Text(member.name)
                .font(Font.AppFont.textCaption)
                .foregroundColor(Color.ProfileSemantics.memberName)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Button(action: onShowDetails) {
                Text("Show Details")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.Teal.teal1000)
                    .clipShape(Capsule())
            }
        }
        .padding(8)
        .frame(width: ProfileSemantics.Sizes.memberCardWidth,
               height: ProfileSemantics.Sizes.memberCardHeight)
        .background(Color.ProfileSemantics.memberCardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: ProfileSemantics.Radius.memberCardRadius)
                .stroke(Color.ProfileSemantics.memberCardBorder, lineWidth: ProfileSemantics.Border.memberCardBorderWidth)
        )
        .clipShape(RoundedRectangle(cornerRadius: ProfileSemantics.Radius.memberCardRadius))
    }
}
