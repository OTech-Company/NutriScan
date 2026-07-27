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
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 16)
            
            if viewModel.isLoading && viewModel.scans.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.errorMessage, viewModel.scans.isEmpty {
                ScanHistoryErrorView(errorMessage: error) {
                    Task {
                        await viewModel.loadScanHistory()
                    }
                }
            } else if viewModel.scans.isEmpty {
                ScanHistoryEmptyStateView()
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.scans) { scan in
                            HistoryRowView(
                                item: UiStateHistoryItem(
                                    id: scan.id,
                                    title: scan.productName,
                                    scannedAt: viewModel.formatDate(scan.scannedAt),
                                    imageName: scan.imageUrl,
                                    status: scan.status
                                )
                            )
                            .onAppear {
                                viewModel.loadNextPageIfNeeded(currentItem: scan)
                            }
                        }
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .padding()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 24)
                }
            }
        }
        .background(Color(light: .white, dark: Color.Teal.teal1600).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.loadScanHistory()
        }
    }
}

#Preview {
    ScanHistoryFactory.makeScanHistoryView()
}
