//
//  AccountRestorationRepositoryProtocol.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import Foundation

protocol AccountRestorationRepositoryProtocol {
    func restoreAccount() async throws -> RestoreAccountResult
}
