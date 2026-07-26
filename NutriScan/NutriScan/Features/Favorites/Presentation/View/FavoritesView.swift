//
//  FavoritesView.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 26/07/2026.
//

import SwiftUI

struct FavoritesView: View {
    
    let viewModel: FavoritesViewModel
    
    var body: some View {
        VStack {
            if !viewModel.favorites.isEmpty {
                FavoritesGridView(savedItems: viewModel.favorites)
            } else {
                Text("Favorites Is Empty...")
            }
        }
        .task {
            await viewModel.loadFavorites()
        }
    }
}

#Preview {
    FavoritesView(viewModel: FavoritesViewModel(favoritesUseCase: FavoritesUseCase(favoritesRepository: FavoritesRepository())))
}
