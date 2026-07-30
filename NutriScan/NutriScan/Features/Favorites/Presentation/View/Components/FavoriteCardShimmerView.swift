//
//  FavoriteCardShimmerView.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 28/07/2026.
//

import SwiftUI
import Shimmer

struct FavoriteCardShimmerView: View {
    
    var body: some View {
        VStack(spacing: 12) {
            // Image placeholder
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.15))
                .frame(height: 140)
            
            // Title row: title + condition badge on left, calories on right
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    // Title placeholder
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.15))
                        .frame(width: 100, height: 14)
                    
                    // Condition badge placeholder
                    Capsule()
                        .fill(Color.gray.opacity(0.15))
                        .frame(width: 60, height: 18)
                }
                
                Spacer()
                
                // Calories badge placeholder
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 40, height: 30)
            }
            
            // Swipe button placeholder
            Capsule()
                .fill(Color.gray.opacity(0.15))
                .frame(height: 24)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .background(Color.Favorites.cardColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .customLightShadow()
        .shimmering()
    }
}

#Preview {
    VStack {
        FavoriteCardShimmerView()
    }
    .padding(.horizontal, 80)
}
