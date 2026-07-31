//
//  HelpRepositoryProtocol.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 30/07/2026.
//

import Foundation

protocol HelpRepositoryProtocol {
    func getFaqs() async throws -> [FaqItem]
}
