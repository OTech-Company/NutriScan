//
//  ProductDetailsRepo.swift
//  NutriScan
//
//  Created by albaraa alsayed on 11/02/1448 AH.
//

import Foundation

protocol ProductDetailsRepo {
    func getProductDetails(scanId: String) async throws -> ProductDetails
}
