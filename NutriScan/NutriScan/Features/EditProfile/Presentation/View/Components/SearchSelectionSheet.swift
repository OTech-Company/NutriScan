//
//  SearchSelectionSheet.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 21/07/2026.
//

import SwiftUI

struct SearchSelectionSheet: View {
    let title: String
    @Binding var searchQuery: String
    let results: [String]
    let onSelect: (String) -> Void

    var body: some View {
        NavigationStack {
            List(results, id: \.self) { item in
                Button(action: {
                    onSelect(item)
                }) {
                    Text(item)
                        .font(Font.AppFont.textDefault)
                        .foregroundColor(
                            Color.EditProfileSemantics.textSecondary
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchQuery, prompt: "Search...")
        }
        .presentationDetents([.medium, .large])
    }
}
