import Foundation

@MainActor
final class DiscoverViewModel: ObservableObject {

    enum ViewState: Equatable {
        case idle
        case loading
        case loaded
        case empty
        case error(String)
    }

    @Published private(set) var articles: [Article] = []
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

    private let fetchTopHeadlinesUseCase: FetchTopHeadlinesUseCaseProtocol
    private let searchArticlesUseCase: SearchArticlesUseCaseProtocol
    private var searchTask: Task<Void, Never>?

    init(
        fetchTopHeadlinesUseCase: FetchTopHeadlinesUseCaseProtocol,
        searchArticlesUseCase: SearchArticlesUseCaseProtocol
    ) {
        self.fetchTopHeadlinesUseCase = fetchTopHeadlinesUseCase
        self.searchArticlesUseCase = searchArticlesUseCase
    }

    func onAppear() async {
        if viewState == .idle {
            await loadCurrentCategory()
        }
    }

    func onPullToRefresh() async {
        if isSearching {
            await performSearch(query: searchText)
        } else {
            await loadCurrentCategory()
        }
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
            articles = result
            viewState = result.isEmpty ? .empty : .loaded
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }

    private func performSearch(query: String) async {
        viewState = .loading
        do {
            let result = try await searchArticlesUseCase.execute(query: query)
            articles = result
            viewState = result.isEmpty ? .empty : .loaded
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }
}
