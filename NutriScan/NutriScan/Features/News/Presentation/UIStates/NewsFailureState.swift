enum NewsFailureState: Equatable {
    case noConnection
    case serverProblem

    var emptyState: EmptyState {
        switch self {
        case .noConnection:
            return .noConnection
        case .serverProblem:
            return .serverProblem
        }
    }
}
