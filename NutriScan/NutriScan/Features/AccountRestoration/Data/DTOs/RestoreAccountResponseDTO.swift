//
//  RestoreAccountResponseDTO.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import Foundation

struct RestoreAccountResponseDTO: Decodable {
    let message: String
    let restoredAt: String?

    func toDomain() -> RestoreAccountResult {
        var parsedDate: Date? = nil
        if let restoredAt {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            parsedDate = formatter.date(from: restoredAt)
            if parsedDate == nil {
                formatter.formatOptions = [.withInternetDateTime]
                parsedDate = formatter.date(from: restoredAt)
            }
        }
        return RestoreAccountResult(
            message: message,
            restoredAt: parsedDate
        )
    }
}
