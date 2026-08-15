//
//  ScanAssembly.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 22/07/2026.
//

import Foundation

struct ScanAssembly: Assembly {
    func assemble(container: DIContainer) {
        let repository = ScanRepositoryImpl()
        container.register(
            type: FetchScansUseCase.self,
            component: FetchScansUseCaseImpl(repository: repository)
        )
        container.register(
            type: SubmitScanImageUseCase.self,
            component: SubmitScanImageUseCaseImpl(repository: repository)
        )
        container.register(
            type: SubmitBarcodeScanUseCase.self,
            component: SubmitBarcodeScanUseCaseImpl(repository: repository)
        )
        container.register(
            type: FetchScanDetailUseCase.self,
            component: FetchScanDetailUseCaseImpl(repository: repository)
        )
    }
}
