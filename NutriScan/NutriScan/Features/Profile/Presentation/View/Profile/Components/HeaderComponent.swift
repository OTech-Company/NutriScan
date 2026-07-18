//
//  HeaderComponent.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//

import SwiftUI

// MARK: - Header Component
struct HeaderComponent: View {
    let fullName: String
    let streakCount: Int
    let badgesCount: Int
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer().frame(height: 50)
            
            // Profile image placeholder
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.white)
            
            Text(fullName)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            HStack(spacing: 12) {
                BadgeLabel(text: "\(streakCount) Day Streak", systemIcon: "flame.fill", color: .orange)
                BadgeLabel(text: "\(badgesCount) Badges Earned", systemIcon: "trophy.fill", color: .yellow)
            }
            
            Spacer().frame(height: 20)
        }
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.1, green: 0.55, blue: 0.55)) // NutriScan Teal
        .clipShape(RoundedCornerShape(radius: 30, corners: [.bottomLeft, .bottomRight]))
    }
}
