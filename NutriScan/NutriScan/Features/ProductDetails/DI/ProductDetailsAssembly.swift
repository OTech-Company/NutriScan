//
//  ProductDetailsAssembly.swift
//  NutriScan
//
//  Created by albaraa alsayed on 12/02/1448 AH.
//

import Foundation

struct ProductDetailsAssembly: Assembly {
    func assemble(container: DIContainer) {
        // Register Repository
        container.register(
            type: ProductDetailsRepo.self,
            component: ProductDetailsRepoImpl(service: ProductDetailsServiceImpl())
        )
        
        // Register Use Case
        container.register(
            type: GetProductDetailsUseCase.self,
            component: GetProductDetailsUseCase(repository: container.resolve(type: ProductDetailsRepo.self))
        )
        container.register(
            type: UpdateFavoriteUseCase.self,
            component: UpdateFavoriteUseCase(repository: container.resolve(type: ProductDetailsRepo.self))
        )
    }
}
