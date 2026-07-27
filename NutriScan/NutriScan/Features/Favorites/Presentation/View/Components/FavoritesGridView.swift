//
//  FavoritesGridView.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 25/07/2026.
//

import SwiftUI

struct FavoritesGridView: View {
    
    let savedItems: [FavoritesScanEntity]
    var onItemAppear: ((FavoritesScanEntity) -> Void)? = nil
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(savedItems, id: \.id) { item in
                    FavoriteCardView(favUIState:
                                        FavUIState(entity: item)
                    )
                    .onAppear {
                        onItemAppear?(item)
                    }
                }
            }
            .padding(.horizontal, 22)
            .padding(.top, 12)
        }
    }
}

#Preview {
    FavoritesView(viewModel: FavoritesViewModel(favoritesUseCase: FavoritesUseCase(favoritesRepository: FavoritesRepository())))
}
