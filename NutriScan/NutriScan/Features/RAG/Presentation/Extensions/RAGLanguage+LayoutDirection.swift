//
//  RAGLanguage+LayoutDirection.swift
//  NutriScan
//
//  Created by Osama Hosam on 24/07/2026.
//

import SwiftUI

extension RAGLanguage {
    var layoutDirection: LayoutDirection {
        self == .arabic ? .rightToLeft : .leftToRight
    }
}
