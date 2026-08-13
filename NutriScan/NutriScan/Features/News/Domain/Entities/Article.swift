//
//  Article.swift
//  NewsFeed (Feature)
//

import Foundation

struct Article: Identifiable, Equatable, Hashable {
    /// The article URL is guaranteed unique by the API and doubles as a
    /// stable identity for List/ForEach diffing.
    var id: String { url }

    let source: NewsSource
    let author: String?
    let title: String
    let description: String?
    let url: String
    let imageURLString: String?
    let publishedAt: Date
    let content: String?

    var imageURL: URL? {
        guard let imageURLString else { return nil }
        return URL(string: imageURLString)
    }

    var articleURL: URL? {
        URL(string: url)
    }
}

#if DEBUG
extension Article {
    static let preview = Article(
        source: NewsSource(id: "business-insider", name: "Business Insider"),
        author: "Kim Schewitz, Kashmira Gander",
        title: "Liver health is the latest wellness obsession",
        description: "Interest in liver health and sales of liver-focused supplements is soaring as people become more aware of the organ's role in overall health.",
        url: "https://www.businessinsider.com/liver-health-latest-wellness-obsession",
        imageURLString: "https://i.insider.com/6a426797360acd489560ccc1?width=1200&format=jpeg",
        publishedAt: Date(timeIntervalSinceNow: -3600 * 5),
        content: "Liver health content is trending online, and supplement sales are through the roof."
    )

    static let previewTwo = Article(
        source: NewsSource(id: "healthline", name: "Healthline"),
        author: "Maya Feller",
        title: "Simple ways to build a balanced plate every day",
        description: "Small, practical changes can make everyday meals more nourishing.",
        url: "https://example.com/balanced-plate",
        imageURLString: "https://images.unsplash.com/photo-1498837167922-ddd27525d352",
        publishedAt: Date(timeIntervalSinceNow: -3600 * 2),
        content: nil
    )

    static let previewThree = Article(
        source: NewsSource(id: "medical-news", name: "Medical News Today"),
        author: "Jordan Lewis",
        title: "What recent research says about sleep and metabolism",
        description: nil,
        url: "https://example.com/sleep-metabolism",
        imageURLString: nil,
        publishedAt: Date(timeIntervalSinceNow: -3600 * 8),
        content: nil
    )

    static let previewFour = Article(
        source: NewsSource(id: "who", name: "WHO"),
        author: nil,
        title: "New global guidance supports healthier daily movement",
        description: nil,
        url: "https://example.com/daily-movement",
        imageURLString: nil,
        publishedAt: Date(timeIntervalSinceNow: -86400),
        content: nil
    )
}
#endif
