//
//  ExploreSectionHeader.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 22/07/2026.
//

import SwiftUI

struct ExploreSectionHeader: View {
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Text("Explore")
                    .font(Font.AppFont.title3)
                    .foregroundColor(Color.HomeSemantic.historyHeaderTitle)
 
                Spacer()
            }
        }
    }
}

#Preview {
    ExploreSectionHeader()
}
