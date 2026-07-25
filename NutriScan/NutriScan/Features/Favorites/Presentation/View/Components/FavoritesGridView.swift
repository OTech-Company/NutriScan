//
//  FavoritesGridView.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 25/07/2026.
//

import SwiftUI

struct FavoritesGridView: View {
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(1..<6) { _ in
                    FavoriteCardView()
                }
            }
            .padding(.horizontal, 22)
            .padding(.top, 12)
        }
    }
}

#Preview {
    FavoritesGridView()
}
