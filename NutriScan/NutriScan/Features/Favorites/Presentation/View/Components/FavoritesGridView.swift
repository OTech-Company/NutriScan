//
//  FavoritesGridView.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 25/07/2026.
//

import SwiftUI

struct FavoritesGridView: View {
    
    let savedItems: [FavUIState]
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(savedItems, id: \.id) { item in
                    FavoriteCardView(favUIState: FavUIState(id: item.id, image: item.image, title: item.title, calories: item.calories, condition: item.condition)
                    )
                }
            }
            .padding(.horizontal, 22)
            .padding(.top, 12)
        }
    }
}

#Preview {
    FavoritesGridView(savedItems: mockFavoriteUIStates)
}

let mockFavoriteUIStates: [FavUIState] = [
    FavUIState(
        id: "1",
        image: "testImage",
        title: "Milk Product",
        calories: 180.0,
        condition: .Safe
    ),
    FavUIState(
        id: "2",
        image: "testImage2",
        title: "Whole Wheat Bread",
        calories: 220.0,
        condition: .Caution
    ),
    FavUIState(
        id: "3",
        image: "testImage3",
        title: "Sugary Snack",
        calories: 450.0,
        condition: .UnSafe
    )
]
