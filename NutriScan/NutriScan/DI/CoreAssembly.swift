//
//  CoreAssembly.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 22/07/2026.
//
//  Registers dependencies shared across every feature (networking,
//  auth token providers, etc.) — anything NOT specific to one feature.
import Foundation

struct CoreAssembly: Assembly {
    func assemble(container: DIContainer) {
        container.register(type: NetworkServiceProtocol.self, component: NetworkService())
    }
}
