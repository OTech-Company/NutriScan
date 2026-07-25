import Foundation

enum ProductError: Error, Equatable {
    case notFound(barcode: String)
    case network(String)
    case decoding
    case unknown

    var userMessage: String {
        switch self {
        case .notFound(let barcode):
            return "No product found for barcode \(barcode)."
        case .network:
            return "Couldn't reach the server. Check your connection."
        case .decoding:
            return "Something went wrong reading the product data."
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}
