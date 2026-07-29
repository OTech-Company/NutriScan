import Foundation

/// Provides user profile data (height/weight) for step analytics by reading from the shared store.
@MainActor
@Observable
final class UserProfileService {
    private let observeProfileUseCase: ObserveProfileUseCaseProtocol

    init(observeProfileUseCase: ObserveProfileUseCaseProtocol = DIContainer.shared.resolve(type: ObserveProfileUseCaseProtocol.self)) {
        self.observeProfileUseCase = observeProfileUseCase
    }

    /// Current height in cm, pulled directly from the reactive store.
    var heightCm: Double? {
        observeProfileUseCase.execute().currentProfile?.heightCm
    }

    /// Current weight in kg, pulled directly from the reactive store.
    var weightKg: Double? {
        observeProfileUseCase.execute().currentProfile?.weightKg
    }

    /// No-op kept for backward compatibility with existing calls. Data is already pre-loaded on app launch.
    func loadProfileIfNeeded() async {}

    /// No-op kept for backward compatibility.
    func reloadProfile() async {}
}
