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
        VStack(spacing: 0) {
            grabberView
            
            titleView
            
            searchBar

            if results.isEmpty {
                emptyStateView
            } else {
                resultsListView
            }
        }
        .background(Color.EditProfileSemantics.backgroundPrimary.ignoresSafeArea())
        .presentationDetents([.medium, .large])
    }

    // MARK: - Subviews

    private var grabberView: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color.Gray.gray400)
            .frame(width: 40, height: 5)
            .padding(.top, 8)
            .padding(.bottom, 16)
    }

    private var titleView: some View {
        Text(title)
            .font(Font.AppFont.title4)
            .foregroundColor(Color.EditProfileSemantics.titlePrimary)
            .padding(.bottom, 16)
    }

    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.EditProfileSemantics.textSecondary)
            
            TextField(
                "",
                text: $searchQuery,
                prompt: Text(LocalizationKeys.Exercise.searchPlaceholder.localized)
                    .foregroundColor(Color.EditProfileSemantics.textSecondary)
            )
            .font(Font.AppFont.textPrimary)
            .foregroundColor(Color.EditProfileSemantics.textTertiary)
        }
        .padding(.horizontal, 16)
        .frame(height: 48)
        .background(Color.EditProfileSemantics.editableSurface)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.EditProfileSemantics.borderPrimary, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
    }

    private var emptyStateView: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 12) {
                Image(systemName: "magnifyingglass.circle")
                    .font(.system(size: 48))
                    .foregroundColor(Color.EditProfileSemantics.textSecondary.opacity(0.6))
                Text(LocalizationKeys.EmptyState.titleNoSearchResults.localized)
                    .font(Font.AppFont.textPrimary)
                    .foregroundColor(Color.EditProfileSemantics.textSecondary)
            }
            .padding(.bottom, 40)
            Spacer()
        }
    }

    private var resultsListView: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(results, id: \.self) { item in
                    resultRow(for: item)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
        }
    }

    private func resultRow(for item: String) -> some View {
        Button(action: {
            onSelect(item)
        }) {
            HStack {
                Text(item)
                    .font(Font.AppFont.textDefault)
                    .foregroundColor(Color.EditProfileSemantics.textTertiary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color.EditProfileSemantics.textSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.EditProfileSemantics.surfacePrimary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.EditProfileSemantics.borderPrimary.opacity(0.5), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
#Preview("Search Selection Sheet") {
    SearchSelectionSheet(
        title: "Select Allergies",
        searchQuery: .constant(""),
        results: ["Peanuts", "Milk", "Egg", "Gluten", "Soy", "Fish"],
        onSelect: { _ in }
    )
}
