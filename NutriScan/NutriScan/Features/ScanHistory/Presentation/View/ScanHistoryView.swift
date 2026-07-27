//
//  ScanHistoryView.swift
//  NutriScan
//
//  Created by Osama Hosam on 16/07/2026.
//

import SwiftUI

struct ScanHistoryView: View {
    @State private var viewModel: ScanHistoryViewModel
    
    init(viewModel: ScanHistoryViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
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
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                }
            }
        }
        .background(Color(light: .white, dark: Color.Teal.teal1600).ignoresSafeArea())
        .navigationTitle("Scan History")
        .task {
            await viewModel.loadScanHistory()
        }
    }
}

// MARK: - Empty State

private struct ScanHistoryEmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color(light: .Gray.gray200, dark: .Teal.teal1400))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 32))
                    .foregroundColor(Color(light: .Gray.gray600, dark: .Gray.gray400))
            }
            
            Text("No Scan History")
                .font(.AppFont.title3)
                .foregroundColor(Color(light: .Gray.gray900, dark: .Gray.gray100))
            
            Text("Your scanned products will appear here.")
                .font(.AppFont.textSecondary)
                .foregroundColor(Color(light: .Gray.gray600, dark: .Gray.gray300))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

// MARK: - Error State

private struct ScanHistoryErrorView: View {
    let errorMessage: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color(light: .Gray.gray200, dark: .Teal.teal1400))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 32))
                    .foregroundColor(.orange)
            }
            
            Text("Something went wrong")
                .font(.AppFont.title3)
                .foregroundColor(Color(light: .Gray.gray900, dark: .Gray.gray100))
            
            Text(errorMessage)
                .font(.AppFont.textSecondary)
                .foregroundColor(Color(light: .Gray.gray600, dark: .Gray.gray300))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: onRetry) {
                Text("Retry")
                    .font(.AppFont.textDefault)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.Teal.teal1000)
                    .clipShape(Capsule())
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    ScanHistoryFactory.makeScanHistoryView()
}
