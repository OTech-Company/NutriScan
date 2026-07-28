import SwiftUI

struct DiscoverView: View {
    @StateObject private var viewModel: DiscoverViewModel
    @EnvironmentObject var router: AppRouter

    init(viewModel: DiscoverViewModel? = nil) {
        if let viewModel {
            _viewModel = StateObject(wrappedValue: viewModel)
        } else {
            let networkService: NetworkServiceProtocol = NetworkService()
            let remoteDataSource: NewsRemoteDataSourceProtocol = NewsRemoteDataSource(networkService: networkService)
            let repository: NewsRepositoryProtocol = NewsRepository(remoteDataSource: remoteDataSource)

            let defaultViewModel = DiscoverViewModel(
                fetchTopHeadlinesUseCase: FetchTopHeadlinesUseCase(repository: repository),
                searchArticlesUseCase: SearchArticlesUseCase(repository: repository)
            )
            _viewModel = StateObject(wrappedValue: defaultViewModel)
        }
    }

    var body: some View {
        ZStack {
            NewsFeedPalette.background.ignoresSafeArea()

            VStack(spacing: 0) {
                SearchBarView(text: $viewModel.searchText)
                    .padding(.horizontal, NewsFeedMetrics.screenPadding)
                    .padding(.top, 8)
                    .padding(.bottom, 12)
                    .onChange(of: viewModel.searchText) { _, newValue in
                        viewModel.onSearchTextChanged(newValue)
                    }

                if !viewModel.isSearching {
                    categoryChipsRow
                        .padding(.bottom, 12)
                }

                ScrollView(.vertical, showsIndicators: false) {
                    feedContent
                        .padding(.horizontal, NewsFeedMetrics.screenPadding)
                        .padding(.bottom, 24)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    router.pop()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(NewsFeedPalette.textPrimary)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Discover")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(NewsFeedPalette.textPrimary)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.onAppear()
        }
        .sheet(item: $viewModel.selectedArticleForReading) { article in
            if let url = article.articleURL {
                SafariView(url: url)
                    .ignoresSafeArea()
            }
        }
        .tint(NewsFeedPalette.accent)
    }

    // MARK: - Category Chips

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

    // MARK: - Feed Content

    @ViewBuilder
    private var feedContent: some View {
        switch viewModel.viewState {
        case .idle, .loading:
            VStack(spacing: 10) {
                ForEach(0..<6, id: \.self) { _ in
                    CompactArticleRowSkeleton()
                }
            }

        case .loaded:
            VStack(spacing: 10) {
                ForEach(viewModel.articles) { article in
                    Button {
                        viewModel.onArticleTapped(article)
                    } label: {
                        CompactArticleRow(article: article)
                    }
                    .buttonStyle(.plain)
                }
            }

        case .empty:
            FeedEmptyStateView()
                .padding(.top, 80)

        case .error(let message):
            FeedErrorStateView(message: message) {
                Task { await viewModel.onPullToRefresh() }
            }
            .padding(.top, 80)
        }
    }
}

#Preview {
    DiscoverView()
}
