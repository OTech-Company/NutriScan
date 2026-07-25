//
//  ArticleMapper.swift
//  NewsFeed (Feature)
//

import Foundation

enum ArticleMapper {
    private static let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()

    static func map(_ dto: ArticleDTO) -> Article {
        Article(
            source: NewsSource(id: dto.source.id, name: dto.source.name),
            author: dto.author,
            title: dto.title,
            description: dto.description,
            url: dto.url,
            imageURLString: dto.urlToImage,
            publishedAt: isoFormatter.date(from: dto.publishedAt) ?? Date(),
            content: dto.content
        )
    }

    static func map(_ dtos: [ArticleDTO]) -> [Article] {
        dtos.map(map)
    }
}
