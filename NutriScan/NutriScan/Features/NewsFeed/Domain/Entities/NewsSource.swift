//
//  NewsSource.swift
//  NewsFeed (Feature)
//
//  Domain entity — plain Swift, no JSON keys, no networking, no UIKit/SwiftUI.
//

import Foundation

struct NewsSource: Equatable, Hashable {
    let id: String?
    let name: String
}
