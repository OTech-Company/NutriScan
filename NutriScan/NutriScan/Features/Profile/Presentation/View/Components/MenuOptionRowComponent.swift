//
//  MenuOptionRowComponent.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//

import SwiftUI

// MARK: - Menu Option Row Component
struct MenuOptionRowComponent: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Color(red: 0.1, green: 0.55, blue: 0.55))
                    .frame(width: 24)
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.footnote)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}
