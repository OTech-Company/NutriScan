import SwiftUI

struct PaginationRetryFooter: View {
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Text(LocalizationKeys.Common.actionFailed.localized)
                .font(.AppFont.textCaption)
                .foregroundColor(Color(light: .Gray.gray600, dark: .Gray.gray400))
            
            Button(action: onRetry) {
                Text(LocalizationKeys.Common.tryAgain.localized)
                    .font(.AppFont.textCaption)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.Teal.teal1000)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }
}

#Preview {
    PaginationRetryFooter(onRetry: {})
}
