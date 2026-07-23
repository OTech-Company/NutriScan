//
//  ActiveAlert.swift
//  NutriScan
//
//  Created by albaraa alsayed on 23/07/2026.
//

import Foundation

enum ActiveAlert: Identifiable, Equatable {
    case none
    case delete
    case success
    case error
    case internetError
    case warning
    
    var id: String { String(describing: self) }
}
