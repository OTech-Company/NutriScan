//
//  NewsEndpoint.swift
//  NewsFeed (Feature)

import Foundation

enum NewsEndpoint: APIEndpoint {
    case topHeadlines(category: String, page: Int, pageSize: Int)
    case everything(query: String, page: Int, pageSize: Int)

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
        case .topHeadlines(let category, let page, let pageSize):
            params["category"] = category
            params["page"] = String(page)
            params["pageSize"] = String(pageSize)
        case .everything(let query, let page, let pageSize):
            params["q"] = query
            params["page"] = String(page)
            params["pageSize"] = String(pageSize)
        }

        return params
    }

    var requiresAuth: Bool {
        false // Set to false because NewsAPI handles auth via the `apiKey` query parameter
    }
}
