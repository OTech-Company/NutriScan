import SwiftUI
import Shimmer

struct NewsInterestChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(NewsFeedTypography.chip)
                .foregroundStyle(
                    isSelected ? NewsFeedPalette.chipSelectedText : NewsFeedPalette.chipText
                )
                .lineLimit(1)
                .padding(.horizontal, 16)
                .frame(height: 34)
                .background(NewsFeedPalette.chipBackground)
                .overlay {
                    Capsule()
                        .strokeBorder(
                            isSelected ? NewsFeedPalette.chipSelectedBorder : NewsFeedPalette.chipBorder,
                            lineWidth: 1
                        )
                }
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

struct NewsInterestChipBar: View {
    let interests: [NewsInterest]
    let selectedInterest: NewsInterest
    let isLoading: Bool
    let onSelect: (NewsInterest) -> Void
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                if isLoading && interests.isEmpty {
                    ForEach([52.0, 84.0, 104.0, 76.0], id: \.self) { width in
                        Capsule()
                            .fill(NewsFeedPalette.skeleton)
                            .frame(width: width, height: 34)
                            .shimmering(active: !reduceMotion)
                    }
                } else {
                    ForEach(interests) { interest in
                        NewsInterestChip(
                            title: interest.displayName,
                            isSelected: interest == selectedInterest
                        ) {
                            if reduceMotion {
                                onSelect(interest)
                            } else {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    onSelect(interest)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, NewsFeedMetrics.screenPadding)
        }
    }
}

#Preview {
    NewsInterestChipBar(
        interests: [.all, .allergy(id: 1, name: "Peanuts"), .disease(id: 2, name: "Diabetes")],
        selectedInterest: .all,
        isLoading: false,
        onSelect: { _ in }
    )
    .padding(.vertical)
    .background(NewsFeedPalette.background)
}
