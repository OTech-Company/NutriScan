//
//  ExerciseSearchBar.swift
//  NutriScan
//

import SwiftUI

// MARK: - Search Bar

struct ExerciseSearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack(spacing: 12) {

            // MARK: Search TextField Container
            HStack(spacing: 8) {
                TextField("", text: $text, prompt: Text("Search here").foregroundColor(Color.ExerciseSemantic.searchPlaceholder))
                    .font(Font.AppFont.textSecondary)
                    .foregroundColor(Color.ExerciseSemantic.searchText)
                    .autocorrectionDisabled()

                if !text.isEmpty {
                    Button { text = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(Color.ExerciseSemantic.searchPlaceholder)
                    }
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 48)
            .background(Color.ExerciseSemantic.searchBackground)
            .overlay(
                Capsule()
                    .strokeBorder(Color.ExerciseSemantic.searchBorder, lineWidth: 1)
            )
            .clipShape(Capsule())

            // MARK: Circle Search Button
            Button {
                // no-op: filtering is reactive via text binding
            } label: {
                Image("search_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.Teal.teal1000)
                    .clipShape(Circle())
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        ExerciseSearchBar(text: .constant(""))
        ExerciseSearchBar(text: .constant("Plank"))
    }
    .padding()
}
