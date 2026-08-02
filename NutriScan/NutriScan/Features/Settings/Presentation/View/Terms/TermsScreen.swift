//
//  TermsScreen.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//

import SwiftUI
import Shimmer

struct TermsScreen: View {
    @EnvironmentObject private var router: AppRouter
    @State private var viewModel: TermsViewModel

    init(viewModel: TermsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color.TermsSemantic.background.ignoresSafeArea()

            VStack(spacing: 0) {
                SettingsHeaderSection(title: "Terms and Conditions", subtitle: nil) {
                    router.pop()
                }

                ScrollView(showsIndicators: false) {
                    VStack(
                        alignment: .leading,
                        spacing: TermsSemantics.Spacing.itemSpacing
                    ) {
                        if viewModel.isLoading {
                            ForEach(TermsItem.dummyItems) { item in
                                TermsSectionCard(item: item)
                                    .redacted(reason: .placeholder)
                                    .shimmering()
                            }
                        } else {
                            ForEach(viewModel.termsItems) { item in
                                TermsSectionCard(item: item)
                            }
                        }
                    }
                    .padding(.horizontal, TermsSemantics.Spacing.screenHorizontal)
                    .padding(.top, 24)
                    .padding(.bottom, 40)
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        .task {
            await viewModel.loadTerms()
        }
    }
}

#Preview("Light Mode") {
    NavigationStack {
        TermsScreen(viewModel: TermsViewModel(getTermsUseCase: GetTermsUseCaseMock()))
            .environmentObject(AppRouter())
            .preferredColorScheme(.light)
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        TermsScreen(viewModel: TermsViewModel(getTermsUseCase: GetTermsUseCaseMock()))
            .environmentObject(AppRouter())
            .preferredColorScheme(.dark)
    }
}

// MARK: - Mock for Preview
private struct GetTermsUseCaseMock: GetTermsUseCaseProtocol {
    func execute() async throws -> [TermsItem] {
        return TermsItem.dummyItems
    }
}
