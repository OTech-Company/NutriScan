//
//  FavoritesGridView.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 25/07/2026.
//

import SwiftUI

struct FavoritesGridView: View {
    
    let savedItems: [FavoritesScanEntity]
    var isLoadingNextPage: Bool = false
    var paginationError: String? = nil
    var onItemAppear: ((FavoritesScanEntity) -> Void)? = nil
    var onRetryPagination: (() -> Void)? = nil
    
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
            
            // MARK: - Pagination Footer
            if isLoadingNextPage {
                ProgressView()
                    .tint(Color.Teal.teal1000)
                    .padding(.vertical, 16)
            } else if paginationError != nil, let onRetry = onRetryPagination {
                PaginationRetryFooter(onRetry: onRetry)
            }
        }
    }
}

#Preview {
    FavoritesFactory.makeFavoritesView()
}
