//
//  ObserveProfileUseCase.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 28/07/2026.
//

import Foundation

protocol ObserveProfileUseCaseProtocol {
    func execute() -> SharedProfileStore
}

struct ObserveProfileUseCase: ObserveProfileUseCaseProtocol {
    private let sharedStore: SharedProfileStore
    
    init(sharedStore: SharedProfileStore = DIContainer.shared.resolve(type: SharedProfileStore.self)) {
        self.sharedStore = sharedStore
    }
    
    func execute() -> SharedProfileStore {
        return sharedStore
    }
}
