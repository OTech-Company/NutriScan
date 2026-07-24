//
//  NewsEndpoint.swift
//  NewsFeed (Feature)

import Foundation

enum NewsEndpoint: APIEndpoint {
    case topHeadlines(category: String)
    case everything(query: String)

    var baseURL: String {
        NewsAPIConfig.baseURL
    }

    var path: String {
        switch self {
        case .topHeadlines:
            return "/top-headlines"
        case .everything:
            return "/everything"
        }
    }

    var method: HTTPMethod {
        .get
    }

    var queryParameters: [String: String]? {
        var params = [
            "apiKey": NewsAPIConfig.apiKey
        ]

        switch self {
        case .topHeadlines(let category):
            params["category"] = category
        case .everything(let query):
            params["q"] = query
        }

        return params
    }

    var requiresAuth: Bool {
        false // Set to false because NewsAPI handles auth via the `apiKey` query parameter
    }
}
