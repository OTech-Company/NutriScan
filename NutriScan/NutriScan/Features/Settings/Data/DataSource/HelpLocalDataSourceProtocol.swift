//
//  HelpLocalDataSourceProtocol.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 30/07/2026.
//

import Foundation

protocol HelpLocalDataSourceProtocol {
    func getFaqs() async throws -> [FaqItem]
}
