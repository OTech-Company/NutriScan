import SwiftUI

struct FavoritesSearchBar: View {
    @Binding var text: String
    var onSearch: () -> Void

    var body: some View {
        HStack(spacing: 12) {

            // MARK: Search TextField Container
            HStack(spacing: 8) {
                TextField("", text: $text, prompt: Text("Search favorites").foregroundColor(Color(light: .Gray.gray600, dark: .Gray.gray400)))
                    .font(Font.AppFont.textSecondary)
                    .foregroundColor(Color(light: .Gray.gray900, dark: .Gray.gray100))
                    .autocorrectionDisabled()
                    .onSubmit {
                        onSearch()
                    }

                if !text.isEmpty {
                    Button { 
                        text = ""
                        onSearch() 
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(Color(light: .Gray.gray600, dark: .Gray.gray400))
                    }
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 48)
            .background(Color(light: .white, dark: Color.Teal.teal1400))
            .overlay(
                Capsule()
                    .strokeBorder(Color(light: .Gray.gray300, dark: .Teal.teal1200), lineWidth: 1)
            )
            .clipShape(Capsule())

            // MARK: Circle Search Button
            Button {
                onSearch()
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

#Preview {
    VStack(spacing: 16) {
        FavoritesSearchBar(text: .constant(""), onSearch: {})
        FavoritesSearchBar(text: .constant("Apple"), onSearch: {})
    }
    .padding()
}
