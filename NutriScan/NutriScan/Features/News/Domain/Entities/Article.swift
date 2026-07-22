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
}
#endif
