//
//  ScanHistoryView.swift
//  NutriScan
//
//  Created by Osama Hosam on 16/07/2026.
//

import SwiftUI

struct ScanHistoryView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var viewModel: ScanHistoryViewModel
    
    init(viewModel: ScanHistoryViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom header with BackButton
            HStack(spacing: 16) {
                BackButton { router.pop() }
                Text("Scan History")
                    .font(.AppFont.title3)
                    .foregroundColor(Color(light: .Gray.gray900, dark: .Gray.gray100))
                Spacer()
            }
            .padding(.horizontal, 22)
            .padding(.top, 16)
            .padding(.bottom, 16)
            
            // MARK: - State-driven content
            if viewModel.isLoadingInitial && viewModel.scans.isEmpty {
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
                            Button(action: {
                                router.push(ProfileRoute.scanDetail(scanId: scan.id))
                            }) {
                                HistoryRowView(
                                    item: UiStateHistoryItem(
                                        id: scan.id,
                                        title: scan.productName,
                                        scannedAt: viewModel.formatDate(scan.scannedAt),
                                        imageName: scan.imageUrl,
                                        status: scan.status
                                    )
                                )
                            }
                            .buttonStyle(.plain)
                            .onAppear {
                                viewModel.loadNextPageIfNeeded(currentItem: scan)
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
                }
                .refreshable {
                    await viewModel.refreshScanHistory()
                }
            }
        }
        .background(Color(light: .white, dark: Color.Teal.teal1600).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.loadScanHistoryIfNeeded()
        }
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

#Preview {
    class MockScanHistoryUseCase: ScanHistoryUseCaseProtocol {
        func getScanHistory(page: Int, size: Int) async throws -> (scans: [ScanHistoryEntity], totalPages: Int) {
            let mockData = [
                ScanHistoryEntity(
                    id: "1",
                    productName: "Almarai Fresh Milk",
                    imageUrl: "",
                    calories: 150,
                    scannedAt: "2026-07-27T10:15:00Z",
                    status: .safe
                ),
                ScanHistoryEntity(
                    id: "2",
                    productName: "Lays Classic Potato Chips",
                    imageUrl: "",
                    calories: 240,
                    scannedAt: "2026-07-26T14:30:00Z",
                    status: .caution
                )
            ]
            return (scans: mockData, totalPages: 1)
        }
    }

    let viewModel = ScanHistoryViewModel(scanHistoryUseCase: MockScanHistoryUseCase())
    return ScanHistoryView(viewModel: viewModel)
        .environmentObject(AppRouter())
}
