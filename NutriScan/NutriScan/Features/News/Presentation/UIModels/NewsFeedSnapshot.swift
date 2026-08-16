struct NewsFeedSnapshot {
    let articles: [Article]
    let viewState: NewsViewState
    let currentPage: Int
    let hasMorePages: Bool
    let paginationFailure: NewsFailureState?
}
