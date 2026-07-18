//
//  ToggleOptionRowComponent.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//

import SwiftUI

// MARK: - Toggle Option Row Component
struct ToggleOptionRowComponent: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color(red: 0.1, green: 0.55, blue: 0.55))
                .frame(width: 24)
            Text(title)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(Color(red: 0.1, green: 0.55, blue: 0.55))
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
