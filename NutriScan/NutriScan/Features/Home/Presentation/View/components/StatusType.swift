import SwiftUI

enum StatusType {
    case safe
    case caution
    case unsafe
    
    var label: String {
        switch self {
        case .safe:
            return "HEALTHY"
        case .caution:
            return "PROBIOTIC"
        case .unsafe:
            return "HIGH\nSUGAR"
        }
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
