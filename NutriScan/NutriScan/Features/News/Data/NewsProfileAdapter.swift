import Foundation

protocol NewsProfileProviding {
    /// `nil` means no profile is available; an empty array means a profile exists with no conditions.
    func cachedInterests() -> [NewsInterest]?
    func refreshInterests() async throws -> [NewsInterest]?
}

final class NewsProfileAdapter: NewsProfileProviding {
    private let fetchAndCacheProfileUseCase: FetchAndCacheProfileUseCaseProtocol
    private let observeProfileUseCase: ObserveProfileUseCaseProtocol

    init(
        fetchAndCacheProfileUseCase: FetchAndCacheProfileUseCaseProtocol,
        observeProfileUseCase: ObserveProfileUseCaseProtocol
    ) {
        self.fetchAndCacheProfileUseCase = fetchAndCacheProfileUseCase
        self.observeProfileUseCase = observeProfileUseCase
    }

    func cachedInterests() -> [NewsInterest]? {
        guard let profile = observeProfileUseCase.execute().currentProfile else { return nil }

        let allergies = profile.allergies.map {
            NewsInterest.allergy(id: $0.id, name: $0.name)
        }
        let diseases = profile.diseases.map {
            NewsInterest.disease(id: $0.id, name: $0.name)
        }
        return allergies + diseases
    }

    func refreshInterests() async throws -> [NewsInterest]? {
        try await fetchAndCacheProfileUseCase.execute()
        return cachedInterests()
    }
}
