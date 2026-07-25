//
//  SafariView.swift
//  NewsFeed (Feature)
//
//  Lets a tapped article open in-app instead of jumping to the system
//  browser. If your app already has a shared SafariView in Core/UI,
//  delete this and use that one instead.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = true
        let controller = SFSafariViewController(url: url, configuration: configuration)
        controller.preferredControlTintColor = UIColor(NewsFeedPalette.accent)
        return controller
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
