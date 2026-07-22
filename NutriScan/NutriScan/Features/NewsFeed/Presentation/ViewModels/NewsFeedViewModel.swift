//
//  NewsFeedViewModel.swift
//  NewsFeed (Feature)
//
//  MVVM ViewModel: exposes @Published state the View binds to, and
//  depends only on use case protocols (never on networking or DTOs).
//

import Foundation

@MainActor
final class NewsFeedViewModel: ObservableObject {

    enum ViewState: Equatable {
        case idle
        case loading
        case loaded
        case empty
        case error(String)
    }

    // MARK: - Published state consumed by the View

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

    // MARK: - Dependencies (use cases, not repositories/data sources)

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

    // MARK: - Intents (called by the View)

    func onAppear() async {
        guard viewState == .idle else { return }
        await loadCurrentCategory()
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

        // Debounce keystrokes so we don't fire a request per character.
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
