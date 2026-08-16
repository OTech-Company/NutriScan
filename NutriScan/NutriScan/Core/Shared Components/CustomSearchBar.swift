//
//  CustomSearchBar.swift
//  NutriScan
//

import SwiftUI

struct CustomSearchBar: View {
    @Binding var text: String
    var prompt: String = LocalizationKeys.Common.searchPlaceholder.localized
    var onSearch: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 12) {
            // MARK: Search TextField Container
            HStack(spacing: 8) {
                TextField("", text: $text, prompt: Text(prompt).foregroundColor(Color.SearchBarSemantic.placeholder))
                    .font(Font.AppFont.textSecondary)
                    .foregroundColor(Color.SearchBarSemantic.text)
                    .autocorrectionDisabled()
                    .onSubmit {
                        onSearch?()
                    }
                
                if !text.isEmpty {
                    Button {
                        text = ""
                        onSearch?()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(Color.SearchBarSemantic.placeholder)
                    }
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 48)
            .background(Color.SearchBarSemantic.background)
            .overlay(
                Capsule()
                    .strokeBorder(Color.SearchBarSemantic.border, lineWidth: 1)
            )
            .clipShape(Capsule())
            
            // MARK: Circle Search Button
            Button {
                onSearch?()
            } label: {
                Image("search_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.SearchBarSemantic.buttonBackground)
                    .clipShape(Circle())
            }
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        CustomSearchBar(text: .constant(""))
        CustomSearchBar(text: .constant("Plank"))
    }
    .padding()
}

// MARK: - Search Bar Semantic Colors
extension Color {
    enum SearchBarSemantic {
        static let text = Color(light: Color.Gray.gray1400, dark: Color.Teal.teal200)
        static let placeholder = Color(light: Color.Gray.gray600, dark: Color.Teal.teal1200)
        static let background = Color(light: .white, dark: Color.Teal.teal1600)
        static let border = Color(light: Color.Gray.gray300, dark: Color.Teal.teal1200)
        static let buttonBackground = Color.Teal.teal1000
    }
}
