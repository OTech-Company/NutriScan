//
//  ScanPageDTO.swift
//  NutriScan
//
//  Created by Osama Hosam on 25/07/2026.
//


struct ScanPageDTO: Decodable {
    let totalElements: Int
    let totalPages: Int
    let pageable: PageableDTO
    let numberOfElements: Int
    let first: Bool
    let last: Bool
    let size: Int
    let content: [ScanListItemDTO]
    let number: Int
    let sort: SortDTO
    let empty: Bool
}

struct PageableDTO: Decodable {
    let unpaged: Bool
    let pageNumber: Int
    let paged: Bool
    let pageSize: Int
    let offset: Int
    let sort: SortDTO
}

struct SortDTO: Decodable {
    let unsorted: Bool
    let sorted: Bool
    let empty: Bool
}

struct ScanListItemDTO: Decodable {
    let scanId: String
    let imageUrl: String?
    let verdict: String?
    let scannedAt: String?
}