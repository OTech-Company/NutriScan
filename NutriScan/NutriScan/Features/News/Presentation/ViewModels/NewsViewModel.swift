import Foundation

@MainActor
final class NewsViewModel: ObservableObject {

    enum ViewState: Equatable {
        case idle
        case loading
        case loaded
        case empty
        case error(String)
    }

    // MARK: - Published state consumed by the View

    @Published private(set) var articles: [Article] = []
    @Published private(set) var personalizedArticles: [Article] = []
    @Published private(set) var isLoadingPersonalized: Bool = false
    @Published private(set) var viewState: ViewState = .idle
    @Published var selectedCategory: NewsFeedCategory = .topHealth {
        didSet {
            guard oldValue != selectedCategory, !isSearching else { return }
            Task { await loadCurrentCategory() }
        }
    }
    @Published var searchText: String = ""
    @Published var isSearching: Bool = false
    @Published var selectedArticleForReading: Article?

    // MARK: - Dependencies

    private let fetchTopHeadlinesUseCase: FetchTopHeadlinesUseCaseProtocol
    private let searchArticlesUseCase: SearchArticlesUseCaseProtocol
    private let fetchPersonalizedNewsUseCase: FetchPersonalizedNewsUseCaseProtocol
    private var searchTask: Task<Void, Never>?

    init(
        fetchTopHeadlinesUseCase: FetchTopHeadlinesUseCaseProtocol,
        searchArticlesUseCase: SearchArticlesUseCaseProtocol,
        fetchPersonalizedNewsUseCase: FetchPersonalizedNewsUseCaseProtocol = FetchPersonalizedNewsUseCase()
    ) {
        self.fetchTopHeadlinesUseCase = fetchTopHeadlinesUseCase
        self.searchArticlesUseCase = searchArticlesUseCase
        self.fetchPersonalizedNewsUseCase = fetchPersonalizedNewsUseCase
    }

    // MARK: - Intents

    func onAppear() async {
        if viewState == .idle {
            await loadCurrentCategory()
        }
        if personalizedArticles.isEmpty {
            await loadPersonalizedNews()
        }
    }

    func onPullToRefresh() async {
        if isSearching {
            await performSearch(query: searchText)
        } else {
            await loadCurrentCategory()
        }
        await loadPersonalizedNews()
    }

    func onSearchTextChanged(_ newValue: String) {
        searchTask?.cancel()
        isSearching = !newValue.trimmingCharacters(in: .whitespaces).isEmpty

        guard isSearching else {
            Task { await loadCurrentCategory() }
            return
        }

        searchTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 400_000_000)
            guard !Task.isCancelled else { return }
            await self?.performSearch(query: newValue)
        }
    }

    func onArticleTapped(_ article: Article) {
        selectedArticleForReading = article
    }

    // MARK: - Private loading logic

    private func loadCurrentCategory() async {
        viewState = .loading
        do {
            let query = selectedCategory.searchQuery
            let result: [Article]
            if let query {
                result = try await searchArticlesUseCase.execute(query: query)
            } else {
                result = try await fetchTopHeadlinesUseCase.execute(category: "health")
            }
            apply(result)
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }

    private func loadPersonalizedNews() async {
        isLoadingPersonalized = true
        defer { isLoadingPersonalized = false }
        do {
            personalizedArticles = try await fetchPersonalizedNewsUseCase.execute()
        } catch {
            personalizedArticles = []
        }
    }

    private func performSearch(query: String) async {
        viewState = .loading
        do {
            let result = try await searchArticlesUseCase.execute(query: query)
            apply(result)
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }

    private func apply(_ result: [Article]) {
        articles = result
        viewState = result.isEmpty ? .empty : .loaded
    }
}
