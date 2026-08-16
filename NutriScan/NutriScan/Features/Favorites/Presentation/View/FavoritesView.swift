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
    private enum AlertDestination: String, Identifiable {
        case remove
        case addMealError
        case noInternet
        var id: String { rawValue }
    }

    @EnvironmentObject private var router: AppRouter
    let viewModel: FavoritesViewModel
    @State private var searchText = ""
    @State private var appliedSearchText = ""
    
    @State private var alert: AlertDestination?
    @State private var itemToRemove: FavoritesScanEntity? = nil
    @State private var itemToRetryAddMeal: String? = nil
    @State private var addMealErrorMessage = ""
    
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
                        alert = .remove
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
                                if viewModel.addMealFailure == .offline {
                                    alert = .noInternet
                                } else {
                                    addMealErrorMessage = viewModel.addMealFailure?.message ?? "Something went wrong while adding this product to your daily meals. Please try again."
                                    itemToRetryAddMeal = scanId
                                    alert = .addMealError
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
        .customAlert(
            item: $alert,
            config: { alert in
                switch alert {
                case .remove:
                    return CustomAlertConfig(
                        type: .delete,
                        title: "Remove Product",
                        message: "Are you sure you want to remove \"\(itemToRemove?.productName ?? "")\" from your favorites?",
                        primaryButton: CustomAlertButton("Remove", role: .destructive),
                        secondaryButton: CustomAlertButton("Cancel", role: .cancel)
                    )
                case .addMealError:
                    return CustomAlertConfig(
                        type: .error,
                        title: "Couldn't Add Meal",
                        message: addMealErrorMessage,
                        primaryButton: CustomAlertButton("Try Again"),
                        secondaryButton: CustomAlertButton("Dismiss", role: .cancel)
                    )
                case .noInternet:
                    return CustomAlertConfig(
                        type: .noInternet,
                        title: "No Internet Connection",
                        message: "Please check your connection and try again."
                    )
                }
            },
            primaryAction: { alert in
                switch alert {
                case .remove:
                    if let scanId = itemToRemove?.id,
                       !viewModel.removeFavorite(scanId: scanId) {
                        self.alert = .noInternet
                    }
                    itemToRemove = nil
                case .addMealError:
                    guard let scanId = itemToRetryAddMeal else { return }
                    viewModel.addMealToDaily(scanId: scanId) { success in
                        guard !success else { return }
                        if viewModel.addMealFailure == .offline {
                            self.alert = .noInternet
                        } else {
                            addMealErrorMessage = viewModel.addMealFailure?.message ?? "Something went wrong. Please try again."
                            self.alert = .addMealError
                        }
                    }
                case .noInternet:
                    break
                }
            },
            secondaryAction: { alert in
                if alert == .remove {
                    itemToRemove = nil
                } else if alert == .addMealError {
                    addMealErrorMessage = ""
                    itemToRetryAddMeal = nil
                }
            }
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
