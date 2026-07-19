//
//  LottieView.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 20/07/2026.
//

import SwiftUI
import WebKit

struct LottieView: UIViewRepresentable {
    let jsonName: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        
        // Find path to JSON file in bundle
        if let jsonURL = Bundle.main.url(forResource: jsonName, withExtension: "json"),
           let jsonData = try? Data(contentsOf: jsonURL),
           let jsonString = String(data: jsonData, encoding: .utf8) {
                
            let htmlWithJson = """
            <!DOCTYPE html>
            <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
                <style>
                    body, html {
                        margin: 0;
                        padding: 0;
                        width: 100%;
                        height: 100%;
                        overflow: hidden;
                        background-color: transparent;
                    }
                    #lottie {
                        width: 100%;
                        height: 100%;
                    }
                </style>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/lottie-web/5.12.2/lottie.min.js"></script>
            </head>
            <body>
                <div id="lottie"></div>
                <script>
                    var animation = lottie.loadAnimation({
                        container: document.getElementById('lottie'),
                        renderer: 'svg',
                        loop: false,
                        autoplay: true,
                        animationData: \(jsonString)
                    });
                </script>
            </body>
            </html>
            """
            webView.loadHTMLString(htmlWithJson, baseURL: nil)
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
