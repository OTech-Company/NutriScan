//
//  ScanRoute.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//
import SwiftUI

enum ScanRoute: Route {
    case scan
    case productDetail(barcode: String)

    @ViewBuilder
    var destination: some View {
        switch self {
        case .scan:
            ScanScreen()
        case .productDetail(let barcode):
            ProductDetailView(barcode: barcode)
        }
    }
}
