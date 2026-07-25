//
//  RAGRoute.swift
//  NutriScan
//

import SwiftUI

enum RAGRoute: Route {
    case chat

    @ViewBuilder
    var destination: some View {
        switch self {
        case .chat:
            RAGFlowView()
        }
    }
}
