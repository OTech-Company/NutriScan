import Foundation

/// Pure business entity. No SwiftUI/UIKit/network types here.
struct Product: Identifiable, Equatable {
    let id: String              // e.g. the barcode itself, or a backend product ID
    let barcode: String
    let brand: String
    let name: String
    let imageURL: URL?
    let healthTag: HealthTag?

    enum HealthTag: Equatable {
        case healthy
        case probiotic
        case highSugar
        case custom(String)
    }
}
