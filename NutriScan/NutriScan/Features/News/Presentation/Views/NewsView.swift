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
        ZStack {
            NewsFeedPalette.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: NewsFeedMetrics.cardSpacing) {
                    // Personalized for You section
                    if !viewModel.personalizedArticles.isEmpty {
                        personalizedSection
                    }

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
        .tint(NewsFeedPalette.accent)
    }

    // MARK: - Personalized Section

    private var personalizedSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "person.fill")
                    .foregroundColor(NewsFeedPalette.accent)
                Text("Personalized for You")
                    .font(NewsFeedTypography.eyebrow)
                    .foregroundColor(NewsFeedPalette.textPrimary)
                Spacer()
            }
            .padding(.horizontal, NewsFeedMetrics.screenPadding)
            .padding(.top, 8)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.personalizedArticles) { article in
                        Button {
                            viewModel.onArticleTapped(article)
                        } label: {
                            PersonalizedArticleCard(article: article)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, NewsFeedMetrics.screenPadding)
            }
        }
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

    // MARK: - Content

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

// MARK: - Personalized Article Card

private struct PersonalizedArticleCard: View {
    let article: Article

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let urlString = article.imageURLString, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        Rectangle()
                            .fill(NewsFeedPalette.surfaceMuted)
                            .overlay {
                                Image(systemName: "photo")
                                    .foregroundColor(NewsFeedPalette.textTertiary)
                            }
                    }
                }
                .frame(width: 160, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                Rectangle()
                    .fill(NewsFeedPalette.surfaceMuted)
                    .frame(width: 160, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundColor(NewsFeedPalette.textTertiary)
                    }
            }

            Text(article.title)
                .font(NewsFeedTypography.caption)
                .foregroundColor(NewsFeedPalette.textPrimary)
                .lineLimit(2)
                .frame(width: 160, alignment: .leading)
        }
        .frame(width: 160)
    }
}

#Preview {
    NewsView()
}
