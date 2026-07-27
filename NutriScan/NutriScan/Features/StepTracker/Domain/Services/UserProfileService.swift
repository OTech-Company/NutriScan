import Foundation

/// Fetches and caches the user's profile (height/weight) for use in step analytics.
@MainActor
@Observable
final class UserProfileService {
    private let getProfileUseCase: GetEditProfileUseCaseProtocol
    private(set) var cachedProfile: Profile?
    private(set) var isLoading = false
    private(set) var loadError: String?

    init(getProfileUseCase: GetEditProfileUseCaseProtocol) {
        self.getProfileUseCase = getProfileUseCase
    }

    /// Current height in cm, nil if not set or not loaded.
    var heightCm: Double? {
        cachedProfile?.heightCm
    }

    /// Current weight in kg, nil if not set or not loaded.
    var weightKg: Double? {
        cachedProfile?.weightKg
    }

    /// Loads the profile if not already cached.
    func loadProfileIfNeeded() async {
        guard cachedProfile == nil, !isLoading else { return }
        isLoading = true
        loadError = nil
        do {
            let result = try await getProfileUseCase.execute()
            cachedProfile = result.profile
        } catch {
            loadError = error.localizedDescription
        }
        isLoading = false
    }

    /// Forces a reload of the profile.
    func reloadProfile() async {
        cachedProfile = nil
        await loadProfileIfNeeded()
    }
}