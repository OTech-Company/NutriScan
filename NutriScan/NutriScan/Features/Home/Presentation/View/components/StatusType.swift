import SwiftUI

enum StatusType: String, Codable {
    case safe = "SAFE"
    case caution = "CAUTION"
    case unsafe = "UNSAFE"
    case failed = "FAILED"
    
    var label: String {
        switch self {
        case .failed:
            return "scan field"
        default:
            return self.rawValue
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .safe:
            return Color.HomeSemantic.tagSafeBackground
        case .caution:
            return Color.yellow.opacity(0.1)
        case .unsafe, .failed:
            return Color(light: Color.Red.red100, dark: Color.Red.red500)
        }
    }
    
    var textColor: Color {
        switch self {
        case .safe:
            return Color.HomeSemantic.tagSafeText
        case .caution:
            return Color.yellow
        case .unsafe, .failed:
            return Color(light: Color.Red.red500, dark: Color.Red.red100)
        }
    }
}
