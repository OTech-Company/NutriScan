//
//  DIContainer.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 22/07/2026.
//

import Foundation

final class DIContainer {
    static let shared = DIContainer()
    
    private var services: [String: Any] = [:]
    private let queue = DispatchQueue(label: "com.nutriscan.dicontainer", attributes: .concurrent)
    
    private init() {}
    
    /// Registers a dependency.
    func register<T>(type: T.Type, component: Any) {
        let key = String(describing: type)
        queue.async(flags: .barrier) {
            self.services[key] = component
        }
    }
    
    /// Resolves a dependency. Crashes early if a dependency is missing, catching configuration errors at launch.
    func resolve<T>(type: T.Type) -> T {
        let key = String(describing: type)
        var component: Any?
        
        queue.sync {
            component = self.services[key]
        }
        
        guard let resolvedComponent = component as? T else {
            fatalError("Dependency '\(T.self)' not resolved! Ensure it is registered in AppDependencies.")
        }
        
        return resolvedComponent
    }
}
