enum NewsViewState: Equatable {
    case idle
    case loading
    case loaded
    case empty
    case error(NewsFailureState)
}
