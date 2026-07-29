import SwiftUI

struct ListErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color(light: .Gray.gray200, dark: .Teal.teal1400))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "wifi.exclamationmark")
                    .font(.system(size: 32))
                    .foregroundColor(.orange)
            }
            
            Text("Something Went Wrong")
                .font(.AppFont.title3)
                .foregroundColor(Color(light: .Gray.gray900, dark: .Gray.gray100))
            
            Text(message)
                .font(.AppFont.textSecondary)
                .foregroundColor(Color(light: .Gray.gray600, dark: .Gray.gray300))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: onRetry) {
                Text("Try Again")
                    .font(.AppFont.textSecondary)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Color.Teal.teal1000)
                    .clipShape(Capsule())
            }
            .padding(.top, 8)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    ListErrorView(message: "Could not connect to the server.", onRetry: {})
}
