//
//  ProfileAssembly.swift
//  NutriScan
//
import Foundation

struct ProfileAssembly: Assembly {
    func assemble(container: DIContainer) {
        // Profile view models and views now resolve their requirements
        // directly from the SharedProfileAssembly use cases.
    }
}
