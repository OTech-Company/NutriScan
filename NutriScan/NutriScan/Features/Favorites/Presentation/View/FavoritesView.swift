//
//  FavoritesView.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 26/07/2026.
//

import SwiftUI

struct FavoritesFlowView: View {
    @ObservedObject var router: AppRouter
    let viewModel: FavoritesViewModel

    var body: some View {
        NavigationStack(path: $router.path) {
            FavoritesView(viewModel: viewModel)
                .navigationDestination(for: AnyRoute.self) { route in
                    route.view()
                }
        }
        .environmentObject(router)
    }
}

struct FavoritesView: View {
    @EnvironmentObject private var router: AppRouter
    let viewModel: FavoritesViewModel
    @State private var searchText = ""
    @State private var appliedSearchText = ""
    
    // MARK: - Alert States
    @State private var showRemoveAlert = false
    @State private var itemToRemove: FavoritesScanEntity? = nil
    
    @State private var showAddMealErrorAlert = false
    @State private var itemToRetryAddMeal: String? = nil
    @State private var addMealErrorMessage = ""
    
    @State private var showNoInternetAlert = false
    
    var body: some View {
        VStack(spacing: 16) {
            CustomSearchBar(
                text: $searchText,
                prompt: "Search favorites",
                onSearch: {
                    appliedSearchText = searchText
                    Task {
                        let searchParam = appliedSearchText.isEmpty ? nil : appliedSearchText
                        await viewModel.loadFavorites(search: searchParam)
                    }
                }
            )
            .padding(.horizontal, 20)
            .padding(.top, 24)
            
            // MARK: - State-driven content
            if viewModel.isLoadingInitial && viewModel.favorites.isEmpty {
                // Shimmer placeholder during initial load
                shimmerGrid
                
            } else if let emptyState = displayedEmptyState {
                // Handle connectivity, saved-list, and search empty states.
                EmptyStateView(emptyState: emptyState) {
                    if emptyState == .noConnection || emptyState == .serverProblem {
                        Task {
                            await viewModel.loadFavorites()
                        }
                    } else if emptyState == .noScans || emptyState == .noSaved {
                        router.push(ProfileRoute.scanHistory)
                    } else if emptyState == .noSearchResults {
                        searchText = ""
                        appliedSearchText = ""
                        Task {
                            await viewModel.loadFavorites()
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.bottom, CustomAnimatedTabBar.contentClearance)
                
            } else if !viewModel.favorites.isEmpty {
                // Populated grid with pagination support
                FavoritesGridView(
                    savedItems: viewModel.favorites,
                    isLoadingNextPage: viewModel.isLoadingNextPage,
                    paginationError: viewModel.paginationError,
                    onItemAppear: { item in
                        let searchParam = appliedSearchText.isEmpty ? nil : appliedSearchText
                        viewModel.loadNextPageIfNeeded(currentItem: item, search: searchParam)
                    },
                    onRemoveRequest: { item in
                        itemToRemove = item
                        showRemoveAlert = true
                    },
                    onProductTap: { item in
                        router.push(ProfileRoute.scanDetail(scanId: item.id))
                    },
                    onRetryPagination: {
                        viewModel.retryPagination()
                    },
                    onAddToDaily: { scanId, completion in
                        viewModel.addMealToDaily(scanId: scanId) { success in
                            completion(success)
                            if !success {
                                if viewModel.addMealError == "No internet connection" {
                                    showNoInternetAlert = true
                                } else {
                                    addMealErrorMessage = viewModel.addMealError ?? "Something went wrong while adding this product to your daily meals. Please try again."
                                    itemToRetryAddMeal = scanId
                                    showAddMealErrorAlert = true
                                }
                            }
                        }
                    }
                )
                .refreshable {
                    await viewModel.refreshFavorites()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(light: .white, dark: Color.Teal.teal1600).ignoresSafeArea())
        .onAppear {
            Task {
                await viewModel.loadIfNeeded()
            }
        }
        // MARK: - Remove Confirmation Alert
        .customAlert(
            isPresented: $showRemoveAlert,
            type: .delete,
            title: "Remove Product",
            description: "Are you sure you want to remove \"\(itemToRemove?.productName ?? "")\" from your favorites?",
            primaryButtonTitle: "Remove",
            primaryButtonColor: Color.Red.red500,
            primaryAction: {
                if let scanId = itemToRemove?.id {
                    let success = viewModel.removeFavorite(scanId: scanId)
                    if !success {
                        // Show the no internet alert after the current alert dismisses
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            showNoInternetAlert = true
                        }
                    }
                }
            },
            secondaryButtonTitle: "Cancel",
            secondaryAction: { }
        )
        // MARK: - Add Meal Failure Alert
        .customAlert(
            isPresented: $showAddMealErrorAlert,
            type: .error,
            title: "Couldn't Add Meal",
            description: addMealErrorMessage,
            primaryButtonTitle: "Try Again",
            primaryAction: {
                if let scanId = itemToRetryAddMeal {
                    viewModel.addMealToDaily(scanId: scanId) { success in
                        if !success {
                            addMealErrorMessage = viewModel.addMealError ?? "Something went wrong. Please try again."
                            showAddMealErrorAlert = true
                        }
                    }
                }
            },
            secondaryButtonTitle: "Dismiss",
            secondaryAction: {
                addMealErrorMessage = ""
            }
        )
        // MARK: - No Internet Alert
        .customAlert(
            isPresented: $showNoInternetAlert,
            type: .error,
            title: "No Internet Connection",
            description: "Please check your connection and try again.",
            primaryButtonTitle: "OK",
            primaryAction: { }
        )
    }
    
    // MARK: - Shimmer Grid

    private var displayedEmptyState: EmptyState? {
        guard viewModel.favorites.isEmpty, !viewModel.isLoadingInitial else {
            return viewModel.initialEmptyState
        }

        if let state = viewModel.initialEmptyState {
            switch state {
            case .noScans, .noSaved, .noSearchResults:
                return appliedSearchText.isEmpty ? .noSaved : .noSearchResults
            default:
                return state
            }
        }

        return appliedSearchText.isEmpty ? .noSaved : .noSearchResults
    }
    
    private var shimmerGrid: some View {
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
    }
}

#Preview {
    FavoritesFactory.makeFavoritesView()
        .environmentObject(AppRouter())
}
