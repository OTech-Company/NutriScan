//
//  ObserveProfileUseCase.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 28/07/2026.
//

import Foundation

protocol ObserveProfileUseCaseProtocol {
    func execute() -> UserProfileStore
}

struct ObserveProfileUseCase: ObserveProfileUseCaseProtocol {
    private let sharedStore: UserProfileStore
    
    init(sharedStore: UserProfileStore = DIContainer.shared.resolve(type: UserProfileStore.self)) {
        self.sharedStore = sharedStore
    }
    
    func execute() -> UserProfileStore {
        return sharedStore
    }
}
