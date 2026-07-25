//
//  NewsFeedView.swift
//  NewsFeed (Feature)
//
//  The View is intentionally "dumb": it renders whatever `viewModel`
//  publishes and forwards user intents back to it. No networking,
//  mapping, or business logic lives here.
//

import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel: NewsViewModel

    init(viewModel: NewsViewModel? = nil) {
        if let viewModel {
            _viewModel = StateObject(wrappedValue: viewModel)
        } else {
            let networkService: NetworkServiceProtocol = NetworkService()
            let remoteDataSource: NewsRemoteDataSourceProtocol = NewsRemoteDataSource(networkService: networkService)
            let repository: NewsRepositoryProtocol = NewsRepository(remoteDataSource: remoteDataSource)

            let defaultViewModel = NewsViewModel(
                fetchTopHeadlinesUseCase: FetchTopHeadlinesUseCase(repository: repository),
                searchArticlesUseCase: SearchArticlesUseCase(repository: repository)
            )
            _viewModel = StateObject(wrappedValue: defaultViewModel)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                NewsFeedPalette.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: NewsFeedMetrics.cardSpacing) {
                        SearchBarView(text: $viewModel.searchText)
                            .padding(.horizontal, NewsFeedMetrics.screenPadding)
                            .padding(.top, 4)
                            .onChange(of: viewModel.searchText) { _, newValue in
                                viewModel.onSearchTextChanged(newValue)
                            }

                        if !viewModel.isSearching {
                            categoryChipsRow
                        }

                        content
                            .padding(.horizontal, NewsFeedMetrics.screenPadding)
                    }
                    .padding(.bottom, 24)
                }
                .refreshable {
                    await viewModel.onPullToRefresh()
                }
            }
            .navigationTitle("NutriScan News")
            .navigationBarTitleDisplayMode(.large)
            .task {
                await viewModel.onAppear()
            }
            .sheet(item: $viewModel.selectedArticleForReading) { article in
                if let url = article.articleURL {
                    SafariView(url: url)
                        .ignoresSafeArea()
                }
            }
        }
        .tint(NewsFeedPalette.accent)
    }

    // MARK: - Subviews

    private var categoryChipsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(NewsFeedCategory.allCases) { category in
                    CategoryChipView(
                        title: category.displayName,
                        isSelected: viewModel.selectedCategory == category
                    ) {
                        viewModel.selectedCategory = category
                    }
                }
            }
            .padding(.horizontal, NewsFeedMetrics.screenPadding)
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.viewState {
        case .idle, .loading:
            ArticleFeedSkeletonList()
                .padding(.horizontal, -NewsFeedMetrics.screenPadding)

        case .loaded:
            LazyVStack(spacing: NewsFeedMetrics.cardSpacing) {
                ForEach(viewModel.articles) { article in
                    Button {
                        viewModel.onArticleTapped(article)
                    } label: {
                        ArticleCardView(article: article)
                    }
                    .buttonStyle(.plain)
                }
            }

        case .empty:
            FeedEmptyStateView()

        case .error(let message):
            FeedErrorStateView(message: message) {
                Task { await viewModel.onPullToRefresh() }
            }
        }
    }
}

#Preview {
    NewsView()
}
