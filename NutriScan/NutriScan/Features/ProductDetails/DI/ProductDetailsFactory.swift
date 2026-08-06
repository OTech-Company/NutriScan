//
//  ProductDetailsFactory.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 05/08/2026.
//

import Foundation

@MainActor
enum ProductDetailsFactory {

    static func makeProductDetailsViewModel(scanId: String) -> ProductDetailsViewModel {
        let useCase = DIContainer.shared.resolve(type: GetProductDetailsUseCase.self)
        let repo = DIContainer.shared.resolve(type: ProductDetailsRepo.self)

        return ProductDetailsViewModel(
            scanId: scanId,
            useCase: useCase,
            repo: repo
        )
    }

    static func makeProductDetailsViewModel(scanDetail: ScanDetail) -> ProductDetailsViewModel {
        let useCase = DIContainer.shared.resolve(type: GetProductDetailsUseCase.self)
        let repo = DIContainer.shared.resolve(type: ProductDetailsRepo.self)

        return ProductDetailsViewModel(
            scanDetail: scanDetail,
            useCase: useCase,
            repo: repo
        )
    }
}
