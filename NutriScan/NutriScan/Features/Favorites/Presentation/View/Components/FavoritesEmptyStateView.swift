import SwiftUI

struct FavoritesEmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color(light: .Gray.gray200, dark: .Teal.teal1400))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "bookmark.slash")
                    .font(.system(size: 32))
                    .foregroundColor(Color(light: .Gray.gray600, dark: .Gray.gray400))
            }
            
            Text("No Saved Scans")
                .font(.AppFont.title3)
                .foregroundColor(Color(light: .Gray.gray900, dark: .Gray.gray100))
            
            Text("Scan and save your favorite products to see them here.")
                .font(.AppFont.textSecondary)
                .foregroundColor(Color(light: .Gray.gray600, dark: .Gray.gray300))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    FavoritesView(viewModel: FavoritesViewModel(favoritesUseCase: FavoritesUseCase(favoritesRepository: FavoritesRepository())))
}
