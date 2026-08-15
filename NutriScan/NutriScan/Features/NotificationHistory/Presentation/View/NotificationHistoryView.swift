//
//  NotificationHistoryView.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 05/08/2026.
//

import SwiftUI

struct NotificationHistoryView: View {
    @StateObject var viewModel: NotificationHistoryViewModel
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        VStack(spacing: 0) {
            // Header Section
            NotificationHistoryHeader(
                onBack: {
                    router.pop()
                },
                onClearAll: {
                    viewModel.requestClearAll()
                },
                onSettingsTap: {
                    router.push(SettingsRoute.notificationSettings)
                }
            )

            // Content Section
            if viewModel.items.isEmpty {
                Spacer()
                NotificationHistoryEmptyView()
                Spacer()
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.items) { item in
                            NotificationHistoryCardView(
                                item: item,
                                onTap: {
                                    withAnimation(.easeInOut) {
                                        viewModel.markAsRead(id: item.id)
                                    }
                                }
                            )
                            .contextMenu {
                                Button(role: .destructive) {
                                    withAnimation(.easeInOut) {
                                        viewModel.deleteSingleItem(id: item.id)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                }
            }
        }
        .background(Color.NotificationHistorySemantic.screenBackground.ignoresSafeArea())
        .navigationBarHidden(true)
        .ignoresSafeArea(edges: .top)
        .onAppear {
            viewModel.loadHistory()
        }
        .customAlert(
            isPresented: $viewModel.showClearAllAlert,
            type: .warning,
            title: LocalizationKeys.Notifications.clearAllTitle.localized,
            description: LocalizationKeys.Notifications.clearAllDesc.localized,
            primaryButtonTitle: LocalizationKeys.Notifications.clearAll.localized,
            primaryButtonColor: Color.Red.red500,
            primaryAction: {
                withAnimation(.easeInOut) {
                    viewModel.confirmClearAll()
                }
            },
            secondaryButtonTitle: LocalizationKeys.Common.cancel.localized,
            secondaryAction: {
                viewModel.showClearAllAlert = false
            }
        )
    }
}

#Preview {
    let mockDataSource = NotificationHistoryLocalDataSource()
    let mockRepo = NotificationHistoryRepositoryImpl(dataSource: mockDataSource)
    let vm = NotificationHistoryViewModel(
        getHistoryUseCase: GetNotificationHistoryUseCase(repository: mockRepo),
        clearHistoryUseCase: ClearNotificationHistoryUseCase(repository: mockRepo),
        deleteItemUseCase: DeleteNotificationHistoryItemUseCase(repository: mockRepo),
        markAsReadUseCase: MarkNotificationAsReadUseCase(repository: mockRepo)
    )

    return NavigationStack {
        NotificationHistoryView(viewModel: vm)
            .environmentObject(AppRouter())
    }
}
