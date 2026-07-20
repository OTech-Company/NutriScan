//
//  TokenProviding.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 20/07/2026.
//

import Foundation

protocol TokenProviding {
    func accessToken() async -> String?
}
