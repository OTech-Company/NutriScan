//
//  FavoritesView.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 26/07/2026.
//

import SwiftUI

struct FavoritesView: View {
    
    let viewModel: FavoritesViewModel
    @State private var searchText = ""
    @State private var appliedSearchText = ""
    
    var filteredFavorites: [FavoritesScanEntity] {
        if appliedSearchText.isEmpty {
            return viewModel.favorites
        } else {
            return viewModel.favorites.filter { $0.productName.localizedCaseInsensitiveContains(appliedSearchText) }
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            FavoritesSearchBar(text: $searchText, onSearch: {
                appliedSearchText = searchText
            })
                .padding(.horizontal, 20)
                .padding(.top, 24)
            
            if viewModel.isLoadingFavorites && viewModel.favorites.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if !filteredFavorites.isEmpty {
                FavoritesGridView(savedItems: filteredFavorites)
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
