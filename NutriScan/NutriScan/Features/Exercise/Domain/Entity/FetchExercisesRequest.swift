//
//  FetchExercisesRequest.swift
//  NutriScan
//

import Foundation

struct FetchExercisesRequest: Equatable {
    var page: Int
    var limit: Int
    var bodyPart: String?
    var searchQuery: String?

    init(
        page: Int = 1,
        limit: Int = 20,
        bodyPart: String? = nil,
        searchQuery: String? = nil
    ) {
        self.page = page
        self.limit = limit
        self.bodyPart = bodyPart
        self.searchQuery = searchQuery
    }
}
