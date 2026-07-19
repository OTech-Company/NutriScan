//
//  HealthProfileCardComponent.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//

import SwiftUI

// MARK: - Health Profile Card Component
struct HealthProfileCardComponent: View {
    let completionPercentage: Int
    let onEditClicked: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 10) {
                    Image(systemName: "cross.case.fill")
                        .foregroundColor(Color(red: 0.1, green: 0.55, blue: 0.55))
                        .font(.title2)
                    Text("My Health Profile")
                        .font(.headline)
                        .fontWeight(.bold)
                }
                Spacer()
                Button(action: onEditClicked) {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.gray)
                }
            }
            
            ProgressView(value: Double(completionPercentage), total: 100)
                .tint(Color(red: 0.1, green: 0.55, blue: 0.55))
            
            HStack {
                Text("Profile Completion:")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("\(completionPercentage)%")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.1, green: 0.55, blue: 0.55))
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}
