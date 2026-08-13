import Foundation

@MainActor
final class NewsViewModel: ObservableObject {
    enum FailureState: Equatable {
        case noConnection
        case serverProblem
    }

    enum ViewState: Equatable {
        case idle
        case loading
        case loaded
        case empty
        case error(FailureState)
    }

    @Published private(set) var interests: [NewsInterest] = []
    @Published private(set) var selectedInterest: NewsInterest = .all
    @Published private(set) var articles: [Article] = []
    @Published private(set) var viewState: ViewState = .idle
    @Published private(set) var resultRevision = 0
    @Published private(set) var searchText = ""

    private let fetchNewsInterestsUseCase: FetchNewsInterestsUseCaseProtocol
    private let fetchNewsFeedUseCase: FetchNewsFeedUseCaseProtocol
    private var searchTask: Task<Void, Never>?
    private var feedTask: Task<Void, Never>?
    private var currentRequestID = UUID()
    private var didLoadInitialFeed = false

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
        await loadInterestsAndFeed(guaranteeVisibleLoadingState: false)
    }

    func selectInterest(_ interest: NewsInterest) {
        guard interest != selectedInterest else { return }
        selectedInterest = interest
        startFeedLoad()
    }

    func updateSearchText(_ value: String) {
        searchText = value
        searchTask?.cancel()

        if value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            startFeedLoad()
            return
        }

        searchTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(350))
            guard !Task.isCancelled else { return }
            await self?.loadFeed()
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
        startFeedLoad()
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

    private func startFeedLoad() {
        feedTask?.cancel()
        feedTask = Task { [weak self] in
            await self?.loadFeed()
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
                searchText: searchText
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
                searchText: capturedSearch
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
        let requestID = UUID()
        currentRequestID = requestID
        viewState = .loading
        return requestID
    }

    private func isCurrent(_ requestID: UUID) -> Bool {
        currentRequestID == requestID && !Task.isCancelled
    }

    private func apply(_ result: [Article]) {
        articles = result
        resultRevision += 1
        viewState = result.isEmpty ? .empty : .loaded
    }

    private func failureState(for error: Error) -> FailureState {
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
        searchText: String
    ) async throws -> [Article] { [] }
}
#endif
