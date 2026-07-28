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
    
    var body: some View {
        VStack(spacing: 16) {
            FavoritesSearchBar(text: $searchText, onSearch: {
                appliedSearchText = searchText
                Task {
                    let searchParam = appliedSearchText.isEmpty ? nil : appliedSearchText
                    await viewModel.loadFavorites(search: searchParam)
                }
            })
                .padding(.horizontal, 20)
                .padding(.top, 24)
            
            if viewModel.isLoadingFavorites && viewModel.favorites.isEmpty {
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ], spacing: 12) {
                        ForEach(0..<6, id: \.self) { _ in
                            FavoriteCardShimmerView()
                        }
                    }
                    .padding(.horizontal, 22)
                    .padding(.top, 12)
                }
            } else if !viewModel.favorites.isEmpty {
                FavoritesGridView(savedItems: viewModel.favorites, onItemAppear: { item in
                    let searchParam = appliedSearchText.isEmpty ? nil : appliedSearchText
                    viewModel.loadNextPageIfNeeded(currentItem: item, search: searchParam)
                })
            } else {
                FavoritesEmptyStateView()
            }
        }
        .background(Color(light: .white, dark: Color.Teal.teal1600).ignoresSafeArea())
        .onAppear {
            Task {
                await viewModel.loadIfNeeded()
            }
        }
    }
}

#Preview {
    FavoritesFactory.makeFavoritesView()
}
