import Foundation

protocol FetchNewsInterestsUseCaseProtocol {
    func execute() async throws -> [NewsInterest]
}

enum NewsInterestsError: LocalizedError {
    case profileUnavailable

    var errorDescription: String? {
        "We couldn't load your health profile. Please try again."
    }
}

struct FetchNewsInterestsUseCase: FetchNewsInterestsUseCaseProtocol {
    private let profileProvider: NewsProfileProviding

    init(profileProvider: NewsProfileProviding) {
        self.profileProvider = profileProvider
    }

    func execute() async throws -> [NewsInterest] {
        let cachedInterests = profileProvider.cachedInterests()

        do {
            if let refreshedInterests = try await profileProvider.refreshInterests() {
                return normalized(refreshedInterests)
            }
        } catch {
            if let cachedInterests {
                return normalized(cachedInterests)
            }
            throw error
        }

        guard let cachedInterests else {
            throw NewsInterestsError.profileUnavailable
        }
        return normalized(cachedInterests)
    }

    private func normalized(_ interests: [NewsInterest]) -> [NewsInterest] {
        var seen = Set<String>()
        let profileInterests = interests
            .filter { $0 != .all }
            .filter { seen.insert($0.id).inserted }
        return [.all] + profileInterests
    }
}
