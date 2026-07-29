import SwiftUI
import Shimmer

struct ListRowShimmerView: View {
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color.gray.opacity(0.15))
                .frame(width: 64, height: 64)
            
            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 120, height: 14)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 80, height: 10)
            }
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.15))
                .frame(width: 60, height: 28)
        }
        .padding(.horizontal, 16)
        .frame(height: 96)
        .background(Color(light: .white, dark: Color.Teal.teal1400))
        .cornerRadius(22)
        .redacted(reason: .placeholder)
        .shimmering()
    }
}

#Preview {
    VStack(spacing: 8) {
        ListRowShimmerView()
        ListRowShimmerView()
        ListRowShimmerView()
    }
    .padding(.horizontal, 22)
}
