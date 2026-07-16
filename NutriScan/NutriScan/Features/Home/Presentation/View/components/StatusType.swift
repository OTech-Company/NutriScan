//
//  StatusType.swift
//  NutriScan
//
//  Created by Youssef Abd El-Fatah on 15/07/2026.
//

enum StatusType {
    case safe
    case caution
    case unsafe
    
    var label: String {
        switch self {
        case .safe:
            return "SAFE"
        case .caution:
            return "CAUTION"
        case .unsafe:
            return "UNSAFE"
        }
    }
}
