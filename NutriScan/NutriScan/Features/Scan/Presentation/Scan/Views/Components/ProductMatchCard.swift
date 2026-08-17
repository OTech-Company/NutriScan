import SwiftUI

// MARK: - Models

enum ProductMatchStatus {
    case processing
    case safe
    case caution
    case unsafe
    
    var rawValue: String {
        switch self {
        case .processing: return LocalizationKeys.Scan.processing.localized
        case .safe:       return LocalizationKeys.Scan.safe.localized
        case .caution:    return "Caution"
        case .unsafe:     return LocalizationKeys.Scan.unsafe.localized
        }
    }
}

enum AlertSeverity {
    case safe
    case caution
    case unsafe
    
    var title: String {
        switch self {
        case .safe: return "Safe"
        case .caution: return "Caution"
        case .unsafe: return "Unsafe"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .safe: return Color.Teal.teal400
        case .caution: return Color.orange
        case .unsafe: return Color.red.opacity(0.85)
        }
    }
}

struct FamilyMemberAlert: Identifiable {
    let id = UUID()
    let name: String
    let severity: AlertSeverity
}

// MARK: - ProductMatchCard Component

struct ProductMatchCard: View {
    let status: ProductMatchStatus
    let imageData: Data?
    let productName: String?
    let brandName: String?
    let scanSummary: String?
    var isSaved: Bool = false
    var familyAlerts: [FamilyMemberAlert] = []
    var onSave: (() -> Void)?
    var onRetry: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // MARK: Main Row
            HStack(spacing: 12) {
                productThumbnail

                VStack(alignment: .leading, spacing: 4) {
                    if let brand = brandName {
                        Text(brand.uppercased())
                            .font(.custom("LexendDeca-Medium", size: 11))
                            .foregroundColor(Color.Teal.teal400)
                    }

                    Text(displayTitle)
                        .font(.custom("PlusJakartaSans-Bold", size: 17))
                        .foregroundColor(.white)
                        .lineLimit(1)

                    mainStatusBadge
                }

                Spacer()

                trailingAction
            }

            // MARK: Family Members Alerts Row
            if !familyAlerts.isEmpty && status != .processing {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(familyAlerts) { member in
                            familyStatusBadge(for: member)
                        }
                    }
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.Teal.teal800.opacity(0.92))
        )
        .shadow(color: .black.opacity(0.2), radius: 10, y: 4)
    }

    // MARK: Subviews

    @ViewBuilder
    private var productThumbnail: some View {
        if let imageData, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        } else {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.Teal.teal600.opacity(0.4))
                .frame(width: 64, height: 64)
                .overlay(
                    Image(systemName: "cart.fill")
                        .font(.system(size: 22))
                        .foregroundColor(Color.Teal.teal400)
                )
        }
    }

    private var displayTitle: String {
        switch status {
        case .processing:
            return productName ?? LocalizationKeys.Scan.analyzing.localized
        case .safe, .caution, .unsafe:
            return productName ?? scanSummary ?? LocalizationKeys.Scan.scanComplete.localized
        }
    }

    @ViewBuilder
    private var mainStatusBadge: some View {
        let badgeText: String = {
            switch status {
            case .processing: return status.rawValue
            case .safe: return "Safe for you"
            case .caution: return "Caution for you"
            case .unsafe: return "Unsafe for you"
            }
        }()

        let bgColor: Color = {
            switch status {
            case .processing: return .yellow
            case .safe: return Color.Teal.teal400
            case .caution: return Color.orange
            case .unsafe: return Color.red.opacity(0.85)
            }
        }()

        let textColor: Color = (status == .processing) ? Color(red: 0.1, green: 0.2, blue: 0.25) : .white

        Text(badgeText)
            .font(.custom("LexendDeca-Medium", size: 12))
            .foregroundColor(textColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(bgColor)
            .clipShape(Capsule())
    }

    @ViewBuilder
    private func familyStatusBadge(for member: FamilyMemberAlert) -> some View {
        Text("\(member.severity.title) for \(member.name)")
            .font(.custom("LexendDeca-Medium", size: 12))
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(member.severity.backgroundColor)
            .clipShape(Capsule())
    }

    @ViewBuilder
    private var trailingAction: some View {
        switch status {
        case .processing:
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.Teal.teal400))
                .frame(width: 48, height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.black.opacity(0.15))
                )

        case .safe, .caution, .unsafe:
            if onSave != nil {
                Button {
                    onSave?()
                } label: {
                    Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 48, height: 48)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.Teal.teal400)
                        )
                }
            }
        }
    }
}
