//
//  NewsResponseDTO.swift
//  NewsFeed (Feature)
//
//  Data Transfer Objects mirror the raw NewsAPI JSON 1:1. They are only
//  ever seen by the Data layer — mappers convert them into Domain
//  entities before anything else in the app touches them.
//
//  {
//    "status": "ok",
//    "totalResults": 337,
//    "articles": [ { "source": {...}, "author": ..., "title": ..., ... } ]
//  }
//

import Foundation

struct NewsResponseDTO: Decodable {
    let status: String
    let totalResults: Int
    let articles: [ArticleDTO]
}

struct ArticleDTO: Decodable {
    let source: SourceDTO
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

struct SourceDTO: Decodable {
    let id: String?
    let name: String
}
