import SwiftUI

struct VerdictBadge: View {
    let verdict: ScanVerdict

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: verdictIcon)
                .font(.system(size: 12, weight: .bold))

            Text(verdict.rawValue)
                .font(Font.AppFont.plusJakartaSansSemiBold16)
        }
        .foregroundColor(textColor)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(backgroundColor)
        .clipShape(Capsule())
    }

    private var verdictIcon: String {
        switch verdict {
        case .safe: return "checkmark.shield.fill"
        case .unsafe: return "xmark.shield.fill"
        case .caution: return "exclamationmark.triangle.fill"
        }
    }

    private var textColor: Color {
        switch verdict {
        case .safe: return Color.ScanSemantic.verdictSafeText
        case .unsafe: return Color.ScanSemantic.verdictUnsafeText
        case .caution: return Color.ScanSemantic.verdictCautionText
        }
    }

    private var backgroundColor: Color {
        switch verdict {
        case .safe: return Color.ScanSemantic.verdictSafeBackground
        case .unsafe: return Color.ScanSemantic.verdictUnsafeBackground
        case .caution: return Color.ScanSemantic.verdictCautionBackground
        }
    }
}
