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
            if viewModel.isLoadingFavorites && viewModel.favorites.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if !viewModel.favorites.isEmpty {
                FavoritesGridView(savedItems: viewModel.favorites)
            } else {
                FavoritesEmptyStateView()
            }
        }
        .background(Color(light: .white, dark: Color.Teal.teal1600).ignoresSafeArea())
        .task {
            await viewModel.loadFavorites()
        }
    }
}

#Preview {
    FavoritesFactory.makeFavoritesView()
}
