//
//  DeleteAccountResponseDTO.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import Foundation

struct DeleteAccountResponseDTO: Decodable {
    let scheduledDeletionAt: String
    let gracePeriodDays: Int

    func toDomain() -> DeleteAccountResult {
        DeleteAccountResult(
            scheduledDeletionAt: scheduledDeletionAt,
            gracePeriodDays: gracePeriodDays
        )
    }
}
