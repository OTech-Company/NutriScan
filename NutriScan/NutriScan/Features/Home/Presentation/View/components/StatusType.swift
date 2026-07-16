import SwiftUI

enum StatusType: String, Codable {
    case safe = "SAFE"
    case caution = "CAUTION"
    case unsafe = "UNSAFE"
    
    var label: String {
        return self.rawValue
    }
    
    var backgroundColor: Color {
        switch self {
        case .safe:
            return Color.HomeSemantic.tagSafeBackground
        case .caution:
            return Color.yellow.opacity(0.1)
        case .unsafe:
            return Color.Red.red100
        }
    }
    
    var textColor: Color {
        switch self {
        case .safe:
            return Color.HomeSemantic.tagSafeText
        case .caution:
            return Color.yellow
        case .unsafe:
            return Color.Red.red500
        }
    }
}
