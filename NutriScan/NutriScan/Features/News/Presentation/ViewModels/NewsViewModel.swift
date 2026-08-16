import Foundation

@MainActor
final class NewsViewModel: ObservableObject {
    @Published private(set) var interests: [NewsInterest] = []
    @Published private(set) var selectedInterest: NewsInterest = .all
    @Published private(set) var articles: [Article] = []
    @Published private(set) var viewState: NewsViewState = .idle
    @Published private(set) var resultRevision = 0
    @Published private(set) var searchText = ""
    @Published private(set) var isLoadingNextPage = false
    @Published private(set) var paginationFailure: NewsFailureState?

    private static let pageSize = 20
    private let fetchNewsInterestsUseCase: FetchNewsInterestsUseCaseProtocol
    private let fetchNewsFeedUseCase: FetchNewsFeedUseCaseProtocol
    private var searchTask: Task<Void, Never>?
    private var feedTask: Task<Void, Never>?
    private var paginationTask: Task<Void, Never>?
    private var currentRequestID = UUID()
    private var didLoadInitialFeed = false
    private var currentPage = 0
    private var hasMorePages = false
    private var feedCache: [NewsFeedCacheKey: NewsFeedSnapshot] = [:]

    init(
        fetchNewsInterestsUseCase: FetchNewsInterestsUseCaseProtocol,
        fetchNewsFeedUseCase: FetchNewsFeedUseCaseProtocol
    ) {
        self.fetchNewsInterestsUseCase = fetchNewsInterestsUseCase
        self.fetchNewsFeedUseCase = fetchNewsFeedUseCase
    }

    deinit {
        searchTask?.cancel()
        feedTask?.cancel()
        paginationTask?.cancel()
    }

    var filterLabel: String {
        if selectedInterest != .all {
            return selectedInterest.displayName
        }
        return interests.count > 1 ? "For You" : "Discover"
    }

    var hasSearchQuery: Bool {
        !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func onAppear() async {
        guard !didLoadInitialFeed else { return }
        didLoadInitialFeed = true
        await loadInterestsAndFeed(guaranteeVisibleLoadingState: true)
    }

    func onPullToRefresh() async {
        searchTask?.cancel()
        feedCache.removeAll()
        await loadInterestsAndFeed(guaranteeVisibleLoadingState: false)
    }

    func selectInterest(_ interest: NewsInterest) {
        guard interest != selectedInterest else { return }
        searchTask?.cancel()
        cacheCurrentFeed()
        selectedInterest = interest
        if !restoreCachedFeed(for: interest, searchText: searchText) {
            startFeedLoad()
        }
    }

    func updateSearchText(_ value: String) {
        searchText = value
        searchTask?.cancel()
        invalidateActiveFeedRequest()

        if value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            if !restoreCachedFeed(for: selectedInterest, searchText: value) {
                startFeedLoad()
            }
            return
        }

        searchTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(350))
            guard !Task.isCancelled else { return }
            guard let self else { return }
            if !self.restoreCachedFeed(for: self.selectedInterest, searchText: self.searchText) {
                await self.loadFeed()
            }
        }
    }

    func submitSearch() {
        searchTask?.cancel()
        startFeedLoad()
    }

    func clearSearch() {
        guard !searchText.isEmpty else { return }
        searchText = ""
        searchTask?.cancel()
        if !restoreCachedFeed(for: selectedInterest, searchText: searchText) {
            startFeedLoad()
        }
    }

    func retry() {
        if interests.isEmpty {
            feedTask?.cancel()
            feedTask = Task { [weak self] in
                await self?.loadInterestsAndFeed(guaranteeVisibleLoadingState: false)
            }
        } else {
            startFeedLoad()
        }
    }

    func loadNextPageIfNeeded(currentArticle: Article) {
        guard viewState == .loaded,
              hasMorePages,
              !isLoadingNextPage,
              shouldLoadNextPage(after: currentArticle) else { return }
        startPaginationLoad()
    }

    func retryPagination() {
        guard viewState == .loaded, hasMorePages, !isLoadingNextPage else { return }
        startPaginationLoad()
    }

    private func startFeedLoad() {
        invalidateActiveFeedRequest()
        feedTask = Task { [weak self] in
            await self?.loadFeed()
        }
    }

    private func invalidateActiveFeedRequest() {
        feedTask?.cancel()
        paginationTask?.cancel()
        currentRequestID = UUID()
        isLoadingNextPage = false
        paginationFailure = nil
    }

    private func startPaginationLoad() {
        paginationTask?.cancel()
        isLoadingNextPage = true
        paginationFailure = nil
        let requestID = currentRequestID
        let nextPage = currentPage + 1
        let capturedInterests = interests
        let capturedSelection = selectedInterest
        let capturedSearch = searchText

        paginationTask = Task { [weak self] in
            await self?.loadNextPage(
                requestID: requestID,
                page: nextPage,
                interests: capturedInterests,
                selection: capturedSelection,
                searchText: capturedSearch
            )
        }
    }

    private func loadInterestsAndFeed(guaranteeVisibleLoadingState: Bool) async {
        let requestID = beginRequest()
        let loadingStartedAt = ContinuousClock.now

        do {
            let loadedInterests = try await fetchNewsInterestsUseCase.execute()
            guard isCurrent(requestID) else { return }

            interests = loadedInterests.isEmpty ? [.all] : loadedInterests
            if !interests.contains(selectedInterest) {
                selectedInterest = .all
            }

            let result = try await fetchNewsFeedUseCase.execute(
                availableInterests: interests,
                selectedInterest: selectedInterest,
                searchText: searchText,
                page: 1,
                pageSize: Self.pageSize
            )

            if guaranteeVisibleLoadingState {
                let elapsed = loadingStartedAt.duration(to: .now)
                let minimumDuration = Duration.milliseconds(350)
                if elapsed < minimumDuration {
                    try? await Task.sleep(for: minimumDuration - elapsed)
                }
            }

            guard isCurrent(requestID) else { return }
            apply(result)
        } catch {
            guard isCurrent(requestID), !Task.isCancelled else { return }
            articles = []
            viewState = .error(failureState(for: error))
        }
    }

    private func loadFeed() async {
        guard !interests.isEmpty else {
            await loadInterestsAndFeed(guaranteeVisibleLoadingState: false)
            return
        }

        let requestID = beginRequest()
        let capturedInterests = interests
        let capturedSelection = selectedInterest
        let capturedSearch = searchText

        do {
            let result = try await fetchNewsFeedUseCase.execute(
                availableInterests: capturedInterests,
                selectedInterest: capturedSelection,
                searchText: capturedSearch,
                page: 1,
                pageSize: Self.pageSize
            )
            guard isCurrent(requestID) else { return }
            apply(result)
        } catch {
            guard isCurrent(requestID), !Task.isCancelled else { return }
            articles = []
            viewState = .error(failureState(for: error))
        }
    }

    private func beginRequest() -> UUID {
        paginationTask?.cancel()
        isLoadingNextPage = false
        paginationFailure = nil
        currentPage = 0
        hasMorePages = false
        let requestID = UUID()
        currentRequestID = requestID
        viewState = .loading
        return requestID
    }

    private func isCurrent(_ requestID: UUID) -> Bool {
        currentRequestID == requestID && !Task.isCancelled
    }

    private func apply(_ result: NewsPage) {
        articles = result.articles
        currentPage = 1
        hasMorePages = result.hasMore
        resultRevision += 1
        viewState = result.articles.isEmpty ? .empty : .loaded
        cacheCurrentFeed()
    }

    private func loadNextPage(
        requestID: UUID,
        page: Int,
        interests: [NewsInterest],
        selection: NewsInterest,
        searchText: String
    ) async {
        do {
            let result = try await fetchNewsFeedUseCase.execute(
                availableInterests: interests,
                selectedInterest: selection,
                searchText: searchText,
                page: page,
                pageSize: Self.pageSize
            )
            guard isCurrent(requestID) else { return }

            articles = mergedArticles(existing: articles, incoming: result.articles)
            currentPage = page
            hasMorePages = result.hasMore
            isLoadingNextPage = false
            paginationFailure = nil
            cacheCurrentFeed()
        } catch {
            guard isCurrent(requestID), !Task.isCancelled else { return }
            isLoadingNextPage = false
            paginationFailure = failureState(for: error)
            cacheCurrentFeed()
        }
    }

    private func cacheCurrentFeed() {
        guard viewState == .loaded || viewState == .empty else { return }
        feedCache[cacheKey(for: selectedInterest, searchText: searchText)] = NewsFeedSnapshot(
            articles: articles,
            viewState: viewState,
            currentPage: currentPage,
            hasMorePages: hasMorePages,
            paginationFailure: paginationFailure
        )
    }

    private func restoreCachedFeed(for interest: NewsInterest, searchText: String) -> Bool {
        let key = cacheKey(for: interest, searchText: searchText)
        guard let snapshot = feedCache[key] else { return false }

        feedTask?.cancel()
        paginationTask?.cancel()
        currentRequestID = UUID()
        articles = snapshot.articles
        viewState = snapshot.viewState
        currentPage = snapshot.currentPage
        hasMorePages = snapshot.hasMorePages
        paginationFailure = snapshot.paginationFailure
        isLoadingNextPage = false
        resultRevision += 1
        return true
    }

    private func cacheKey(for interest: NewsInterest, searchText: String) -> NewsFeedCacheKey {
        NewsFeedCacheKey(
            interest: interest,
            searchText: searchText
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
        )
    }

    private func shouldLoadNextPage(after article: Article) -> Bool {
        guard let index = articles.firstIndex(where: { $0.id == article.id }) else { return false }
        let triggerIndex = max(articles.count - 3, 0)
        return index >= triggerIndex
    }

    private func mergedArticles(existing: [Article], incoming: [Article]) -> [Article] {
        var seenURLs = Set<String>()
        var seenTitles = Set<String>()

        return (existing + incoming)
            .filter { article in
                let normalizedTitle = article.title
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .lowercased()
                guard seenURLs.insert(article.url).inserted else { return false }
                return seenTitles.insert(normalizedTitle).inserted
            }
            .sorted { $0.publishedAt > $1.publishedAt }
    }

    private func failureState(for error: Error) -> NewsFailureState {
        guard NetworkMonitor.shared.isConnected else { return .noConnection }

        if isOfflineError(error) {
            return .noConnection
        }
        return .serverProblem
    }

    private func isOfflineError(_ error: Error) -> Bool {
        if let urlError = error as? URLError {
            return [
                .notConnectedToInternet,
                .networkConnectionLost,
                .dataNotAllowed,
                .internationalRoamingOff
            ].contains(urlError.code)
        }

        guard let networkError = error as? NetworkError else { return false }
        switch networkError {
        case .noInternet:
            return true
        case .unknown(let underlyingError):
            return isOfflineError(underlyingError)
        default:
            return false
        }
    }
}

#if DEBUG
extension NewsViewModel {
    enum PreviewState {
        case loading
        case populated
        case empty
        case noConnection
        case serverProblem
        case longCondition
        case noProfileConditions
    }

    static func preview(_ previewState: PreviewState) -> NewsViewModel {
        let viewModel = NewsViewModel(
            fetchNewsInterestsUseCase: PreviewNewsInterestsUseCase(),
            fetchNewsFeedUseCase: PreviewNewsFeedUseCase()
        )
        viewModel.didLoadInitialFeed = true

        switch previewState {
        case .loading:
            viewModel.viewState = .loading
        case .populated:
            viewModel.interests = [.all, .allergy(id: 1, name: "Peanuts"), .disease(id: 2, name: "Diabetes")]
            viewModel.articles = [.preview, .previewTwo, .previewThree, .previewFour]
            viewModel.viewState = .loaded
        case .empty:
            viewModel.interests = [.all, .allergy(id: 1, name: "Peanuts")]
            viewModel.viewState = .empty
        case .noConnection:
            viewModel.interests = [.all]
            viewModel.viewState = .error(.noConnection)
        case .serverProblem:
            viewModel.interests = [.all]
            viewModel.viewState = .error(.serverProblem)
        case .longCondition:
            viewModel.interests = [
                .all,
                .disease(id: 1, name: "Familial Hypercholesterolemia"),
                .allergy(id: 2, name: "Tree Nuts")
            ]
            viewModel.articles = [.preview, .previewTwo]
            viewModel.viewState = .loaded
        case .noProfileConditions:
            viewModel.interests = [.all]
            viewModel.articles = [.preview, .previewTwo]
            viewModel.viewState = .loaded
        }
        return viewModel
    }
}

private struct PreviewNewsInterestsUseCase: FetchNewsInterestsUseCaseProtocol {
    func execute() async throws -> [NewsInterest] { [.all] }
}

private struct PreviewNewsFeedUseCase: FetchNewsFeedUseCaseProtocol {
    func execute(
        availableInterests: [NewsInterest],
        selectedInterest: NewsInterest,
        searchText: String,
        page: Int,
        pageSize: Int
    ) async throws -> NewsPage {
        NewsPage(articles: [], hasMore: false)
    }
}
#endif
