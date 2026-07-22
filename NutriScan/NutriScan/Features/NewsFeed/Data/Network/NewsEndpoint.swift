//
//  NewsEndpoint.swift
//  NewsFeed (Feature)
//
//  Maps 1:1 to the two requests defined in the "NutriScan News" Postman
//  collection: `/v2/everything` (search) and `/v2/top-headlines` (category).
//

import Foundation

enum NewsEndpoint: Endpoint {
    case topHeadlines(category: String)
    case everything(query: String)

    var path: String {
        switch self {
        case .topHeadlines:
            return "/top-headlines"
        case .everything:
            return "/everything"
        }
    }

    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = [
            URLQueryItem(name: "apiKey", value: NewsAPIConfig.apiKey)
        ]

        switch self {
        case .topHeadlines(let category):
            items.append(URLQueryItem(name: "category", value: category))
        case .everything(let query):
            items.append(URLQueryItem(name: "q", value: query))
        }

        return items
    }
}
