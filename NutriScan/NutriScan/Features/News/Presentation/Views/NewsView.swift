import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel: NewsViewModel
    @EnvironmentObject private var router: AppRouter
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var articleToOpen: ArticleBrowserDestination?
    @State private var articleToShare: Article?

    init(viewModel: NewsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            CustomSearchBar(
                text: searchBinding,
                prompt: "Search health news",
                onSearch: viewModel.submitSearch
            )
            .padding(.horizontal, NewsFeedMetrics.screenPadding)
            .padding(.bottom, NewsFeedMetrics.searchBarBottomSpacing)

            NewsInterestChipBar(
                interests: viewModel.interests,
                selectedInterest: viewModel.selectedInterest,
                isLoading: viewModel.viewState == .loading,
                onSelect: viewModel.selectInterest
            )
            .padding(.bottom, NewsFeedMetrics.sectionSpacing)

            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(NewsFeedPalette.background.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await viewModel.onAppear()
        }
        .sheet(item: $articleToOpen) { destination in
            SafariView(url: destination.url)
                .ignoresSafeArea()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .sheet(item: $articleToShare) { article in
            if let url = article.articleURL {
                ShareSheet(activityItems: [article.title, url])
            }
        }
        .tint(NewsFeedPalette.accent)
    }

    private var header: some View {
        HStack(spacing: 16) {
            BackButton { router.pop() }

            Text("News")
                .font(NewsFeedTypography.screenTitle)
                .foregroundStyle(NewsFeedPalette.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.85)

            Spacer()
        }
        .padding(.horizontal, NewsFeedMetrics.screenPadding)
        .padding(.top, 16)
        .padding(.bottom, 16)
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.viewState {
        case .idle, .loading:
            skeletonList
        case .loaded:
            articleList
        case .empty:
            emptyState
        case .error(let failure):
            EmptyStateView(emptyState: failure.emptyState) {
                viewModel.retry()
            }
        }
    }

    private var articleList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: NewsFeedMetrics.cardSpacing) {
                ForEach(Array(viewModel.articles.enumerated()), id: \.element.id) { index, article in
                    NewsArticleCard(
                        article: article,
                        filterLabel: viewModel.filterLabel,
                        onOpen: { openArticle(article) },
                        onShare: { articleToShare = article }
                    )
                    .transition(
                        reduceMotion
                            ? .opacity
                            : .asymmetric(
                                insertion: .opacity.combined(with: .offset(y: 12)),
                                removal: .opacity
                            )
                    )
                    .animation(
                        reduceMotion
                            ? nil
                            : .easeOut(duration: 0.25).delay(min(Double(index) * 0.035, 0.25)),
                        value: viewModel.resultRevision
                    )
                }
            }
            .padding(.horizontal, NewsFeedMetrics.screenPadding)
            .padding(.bottom, 24)
        }
        .refreshable {
            await viewModel.onPullToRefresh()
        }
        .id(viewModel.resultRevision)
    }

    private var skeletonList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: NewsFeedMetrics.cardSpacing) {
                ForEach(0..<4, id: \.self) { _ in
                    NewsArticleCardSkeleton()
                }
            }
            .padding(.horizontal, NewsFeedMetrics.screenPadding)
            .padding(.bottom, 24)
        }
    }

    private var emptyState: some View {
        Group {
            if viewModel.hasSearchQuery {
                EmptyStateView(emptyState: .noSearchResults, action: {
                    viewModel.clearSearch()
                }, actionLabel: "Clear Search")
            } else {
                NewsEmptyStateView {
                    viewModel.retry()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var searchBinding: Binding<String> {
        Binding(
            get: { viewModel.searchText },
            set: viewModel.updateSearchText
        )
    }

    private func openArticle(_ article: Article) {
        guard let url = article.articleURL else { return }
        articleToOpen = ArticleBrowserDestination(url: url)
    }
}

private struct ArticleBrowserDestination: Identifiable {
    let url: URL

    var id: String { url.absoluteString }
}

private struct NewsEmptyStateView: View {
    let onRefresh: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Image("searchPlaceHolder")

            VStack(spacing: 8) {
                Text("No news yet")
                    .font(Font.AppFont.title3)
                    .foregroundStyle(NewsFeedPalette.textPrimary)
                Text("There are no health stories available right now. Check back in a moment.")
                    .font(Font.AppFont.textPrimary)
                    .foregroundStyle(NewsFeedPalette.textSecondary)
                    .multilineTextAlignment(.center)
            }

            Button("REFRESH", action: onRefresh)
                .font(Font.AppFont.textSecondary)
                .foregroundStyle(Color(light: Color.Teal.teal100, dark: Color.Teal.teal1600))
                .padding(.horizontal, 32)
                .frame(height: 44)
                .background(Color.Teal.teal1000, in: Capsule())
        }
        .padding(22)
    }
}

#Preview("Light · Populated") {
    NewsView(viewModel: .preview(.populated))
        .environmentObject(AppRouter())
        .preferredColorScheme(.light)
}

#Preview("Dark · Populated") {
    NewsView(viewModel: .preview(.populated))
        .environmentObject(AppRouter())
        .preferredColorScheme(.dark)
}

#Preview("Loading") {
    NewsView(viewModel: .preview(.loading))
        .environmentObject(AppRouter())
}

#Preview("Empty") {
    NewsView(viewModel: .preview(.empty))
        .environmentObject(AppRouter())
}

#Preview("No Connection") {
    NewsView(viewModel: .preview(.noConnection))
        .environmentObject(AppRouter())
}

#Preview("Server Problem") {
    NewsView(viewModel: .preview(.serverProblem))
        .environmentObject(AppRouter())
}

#Preview("Long Condition") {
    NewsView(viewModel: .preview(.longCondition))
        .environmentObject(AppRouter())
}

#Preview("No Profile Conditions") {
    NewsView(viewModel: .preview(.noProfileConditions))
        .environmentObject(AppRouter())
}

private extension NewsViewModel.FailureState {
    var emptyState: EmptyState {
        switch self {
        case .noConnection:
            return .noConnection
        case .serverProblem:
            return .serverProblem
        }
    }
}
