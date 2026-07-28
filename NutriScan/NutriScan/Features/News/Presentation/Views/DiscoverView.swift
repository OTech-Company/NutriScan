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

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    headerSection
                    searchSection
                    categoryChipsRow
                    feedContent
                }
                .padding(.top, 8)
                .padding(.bottom, 100)
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
        }
        .task {
            await viewModel.onAppear()
        }
        .sheet(item: $viewModel.selectedArticleForReading) { article in
            ArticleDetailView(article: article)
                .environmentObject(router)
        }
        .tint(NewsFeedPalette.accent)
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Discover")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(NewsFeedPalette.textPrimary)

            Text("News from all around the world")
                .font(.system(size: 15))
                .foregroundStyle(NewsFeedPalette.textSecondary)
        }
        .padding(.horizontal, NewsFeedMetrics.screenPadding)
    }

    // MARK: - Search

    private var searchSection: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16))
                .foregroundStyle(NewsFeedPalette.textTertiary)

            TextField("Search", text: $viewModel.searchText)
                .font(.system(size: 15))
                .focused($isSearchFocused)
                .onChange(of: viewModel.searchText) { _, newValue in
                    viewModel.onSearchTextChanged(newValue)
                }

            Spacer()

            Button {} label: {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(NewsFeedPalette.textPrimary)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(NewsFeedPalette.surface)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(NewsFeedPalette.divider, lineWidth: 1)
        )
        .padding(.horizontal, NewsFeedMetrics.screenPadding)
    }

    @FocusState private var isSearchFocused: Bool

    // MARK: - Category Chips

    private var categoryChipsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(NewsFeedCategory.allCases) { category in
                    Button {
                        viewModel.selectedCategory = category
                    } label: {
                        Text(category.displayName)
                            .font(.system(size: 14, weight: viewModel.selectedCategory == category ? .semibold : .regular))
                            .foregroundStyle(viewModel.selectedCategory == category ? .white : NewsFeedPalette.textSecondary)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(viewModel.selectedCategory == category ? NewsFeedPalette.accent : NewsFeedPalette.surface)
                            )
                            .overlay(
                                Capsule()
                                    .stroke(viewModel.selectedCategory == category ? Color.clear : NewsFeedPalette.divider, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
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
            VStack(spacing: 12) {
                ForEach(0..<6, id: \.self) { _ in
                    CompactArticleRowSkeleton()
                }
            }
            .padding(.horizontal, NewsFeedMetrics.screenPadding)

        case .loaded:
            VStack(spacing: 12) {
                ForEach(viewModel.articles) { article in
                    Button {
                        viewModel.onArticleTapped(article)
                    } label: {
                        CompactArticleRow(article: article)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, NewsFeedMetrics.screenPadding)

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
