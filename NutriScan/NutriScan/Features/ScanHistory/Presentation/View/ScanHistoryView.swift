//
//  ScanHistoryView.swift
//  NutriScan
//
//  Created by Osama Hosam on 16/07/2026.
//

import SwiftUI

struct ScanHistoryView: View {
    private enum AlertDestination: String, Identifiable {
        case delete
        case error
        var id: String { rawValue }
    }

    @EnvironmentObject private var router: AppRouter
    @State private var viewModel: ScanHistoryViewModel
    @State private var alert: AlertDestination?
    @State private var scanPendingDeletion: ScanHistoryEntity?
    @State private var searchText = ""
    @State private var appliedSearchText = ""
    
    init(viewModel: ScanHistoryViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom header with BackButton
            HStack(spacing: 16) {
                BackButton { router.pop() }
                Text(LocalizationKeys.ScanHistory.title.localized)
                    .font(Font.AppFont.subtitle1)
                    .foregroundStyle(Color.CaloriesHistorySemantic.title)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                Spacer()
            }
            .padding(.horizontal, 22)
            .padding(.top, 16)
            .padding(.bottom, 8)

            CustomSearchBar(
                text: $searchText,
                prompt: LocalizationKeys.ScanHistory.searchPlaceholder.localized,
                onSearch: {
                    appliedSearchText = searchText
                    Task {
                        if appliedSearchText.isEmpty {
                            viewModel.clearSearch()
                        } else {
                            await viewModel.searchScans(query: appliedSearchText)
                        }
                    }
                }
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            
            // MARK: - State-driven content
            if viewModel.isSearching {
                // Shimmer placeholder while search is in-flight
                shimmerList

            } else if let searchEmpty = viewModel.searchEmptyState, viewModel.isInSearchMode {
                // .noConnection / .serverProblem → retry; .noSearchResults → clear search
                let isRetryable = searchEmpty == .noConnection || searchEmpty == .serverProblem
                EmptyStateView(
                    emptyState: searchEmpty,
                    action: {
                        if isRetryable {
                            Task { await viewModel.searchScans(query: appliedSearchText) }
                        } else {
                            searchText = ""
                            appliedSearchText = ""
                            viewModel.clearSearch()
                        }
                    },
                    actionLabel: isRetryable
                        ? nil  // use the default "Try Again" label from EmptyState
                        : LocalizationKeys.ScanHistory.clearSearch.localized
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            } else if viewModel.isLoadingInitial && viewModel.scans.isEmpty {
                // Shimmer placeholder during initial load
                shimmerList
                
            } else if let error = viewModel.initialLoadError, viewModel.scans.isEmpty {
                // Full-screen error when initial load fails with no data
                ListErrorView(message: error) {
                    Task {
                        await viewModel.loadScanHistory()
                    }
                }
                
            } else if viewModel.scans.isEmpty {
                // Empty state
                ScanHistoryEmptyStateView()
                
            } else {
                // Populated list with pagination
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.scans) { scan in
                            HistoryRowView(
                                item: UiStateHistoryItem(
                                    id: scan.id,
                                    title: scan.productName,
                                    scannedAt: viewModel.formatDate(scan.scannedAt),
                                    imageName: scan.imageUrl,
                                    status: scan.status
                                ),
                                isDisabled: scan.scanStatus == .failed
                            )
                            .contentShape(RoundedRectangle(cornerRadius: 22))
                            .onTapGesture {
                                if scan.scanStatus != .failed {
                                    router.push(ProfileRoute.scanDetail(scanId: scan.id))
                                }
                            }
                            .onLongPressGesture {
                                scanPendingDeletion = scan
                                alert = .delete
                            }
                            .transition(.asymmetric(
                                insertion: .move(edge: .bottom).combined(with: .opacity),
                                removal: .scale(scale: 0.96).combined(with: .opacity)
                            ))
                            .onAppear {
                                if !viewModel.isInSearchMode {
                                    viewModel.loadNextPageIfNeeded(currentItem: scan)
                                }
                            }
                        }
                        
                        // MARK: - Pagination Footer
                        if viewModel.isLoadingNextPage {
                            ProgressView()
                                .tint(Color.Teal.teal1000)
                                .padding()
                        } else if viewModel.paginationError != nil {
                            PaginationRetryFooter {
                                viewModel.retryPagination()
                            }
                        }
                    }
                    .padding(.horizontal, 22)
                    .padding(.top, 8)
                    .padding(.bottom, 24)
                    .animation(.spring(response: 0.28, dampingFraction: 0.85), value: viewModel.scans.map(\.id))
                }
                .refreshable {
                    searchText = ""
                    appliedSearchText = ""
                    viewModel.clearSearch()
                    await viewModel.refreshScanHistory()
                }
            }
        }
        .background(Color(light: .white, dark: Color.Teal.teal1600).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.loadScanHistoryIfNeeded()
        }
        .onChange(of: viewModel.deleteErrorMessage) { _, message in
            if message != nil {
                alert = .error
            }
        }
        .customAlert(
            item: $alert,
            config: { alert in
                switch alert {
                case .delete:
                    return CustomAlertConfig(
                        type: .delete,
                        title: LocalizationKeys.Home.deleteScanTitle.localized,
                        message: LocalizationKeys.Home.deleteScanDesc.localized,
                        primaryButton: CustomAlertButton(LocalizationKeys.Common.delete.localized, role: .destructive),
                        secondaryButton: CustomAlertButton(LocalizationKeys.Common.cancel.localized, role: .cancel)
                    )
                case .error:
                    return CustomAlertConfig(
                        type: .error,
                        title: LocalizationKeys.Home.deleteFailedTitle.localized,
                        message: viewModel.deleteErrorMessage ?? LocalizationKeys.Common.unknownError.localized,
                        primaryButton: CustomAlertButton(LocalizationKeys.Common.ok.localized, role: .destructive)
                    )
                }
            },
            primaryAction: { alert in
                switch alert {
                case .delete:
                    guard let scan = scanPendingDeletion else { return }
                    Task {
                        await viewModel.deleteScan(scan)
                        scanPendingDeletion = nil
                    }
                case .error:
                    viewModel.deleteErrorMessage = nil
                }
            },
            secondaryAction: { alert in
                if alert == .delete {
                    scanPendingDeletion = nil
                }
            }
        )
    }
    
    // MARK: - Shimmer List
    
    private var shimmerList: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(0..<6, id: \.self) { _ in
                    ScanHistoryCardShimmerView()
                }
            }
            .padding(.horizontal, 22)
            .padding(.top, 8)
        }
    }
}

