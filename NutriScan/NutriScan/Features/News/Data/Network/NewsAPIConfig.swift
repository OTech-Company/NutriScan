//
//  NewsAPIConfig.swift
//  NewsFeed (Feature)
//
//  If your app already has a shared networking config elsewhere in the
//  project, delete this and point NewsEndpoint at that instead. This
//  file exists so the NewsFeed folder can be dropped in and compiled
//  on its own.
//
//  ⚠️ Replace the hardcoded key with a secure retrieval mechanism
//  (xcconfig / encrypted plist / remote config) before shipping.
//

import Foundation

enum NewsAPIConfig {
    static let baseURL = "https://newsapi.org/v2"
    static let apiKey = "a06999badc0d4b2ebbe795b1a4891167"
}
