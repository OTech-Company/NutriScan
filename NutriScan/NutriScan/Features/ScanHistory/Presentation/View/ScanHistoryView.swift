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
                    .animation(.spring(response: 0.28, dampingFraction: 0.85), value: viewModel.scans.map(\.id))
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
                    status: .safe,
                    scanStatus: .completed
                ),
                ScanHistoryEntity(
                    id: "2",
                    productName: "Lays Classic Potato Chips",
                    imageUrl: "",
                    calories: 240,
                    scannedAt: "2026-07-26T14:30:00Z",
                    status: .caution,
                    scanStatus: .completed
                )
            ]
            return (scans: mockData, totalPages: 1)
        }

        func deleteScan(scanId: String) async throws {}
    }

    let viewModel = ScanHistoryViewModel(scanHistoryUseCase: MockScanHistoryUseCase())
    return ScanHistoryView(viewModel: viewModel)
        .environmentObject(AppRouter())
}
