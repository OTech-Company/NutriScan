import SwiftUI

extension Color {
    enum ScanSemantic {
        static let background = Color(light: .white, dark: Color.Teal.teal1600)
        static let viewfinderStroke = Color(light: .white, dark: .white)

        static let captureOuterRing = Color(light: Color.Teal.teal1000, dark: Color.Teal.teal500)
        static let captureInnerCircle = Color(light: .white, dark: Color.Teal.teal1600)

        static let scanningOverlay = Color(light: .black.opacity(0.45), dark: .black.opacity(0.6))
        static let scanningText = Color(light: .white, dark: Color.Teal.teal100)
        static let scanningPulse = Color(light: Color.Teal.teal800, dark: Color.Teal.teal400)

        static let resultCardBackground = Color(light: .white, dark: Color.Teal.teal1400)
        static let resultCardShadow = Color(light: .black.opacity(0.1), dark: .black.opacity(0.3))

        static let verdictSafeText = Color(light: Color.Teal.teal1000, dark: Color.Teal.teal400)
        static let verdictSafeBackground = Color(light: Color.Teal.teal100, dark: Color.Teal.teal1500)
        static let verdictUnsafeText = Color(light: Color.Red.red500, dark: Color.Red.red500)
        static let verdictUnsafeBackground = Color(light: Color.Red.red100, dark: Color.Red.red100.opacity(0.2))
        static let verdictCautionText = Color(light: Color.Yellow.yellow500, dark: Color.Yellow.yellow500)
        static let verdictCautionBackground = Color(light: Color.Yellow.yellow500.opacity(0.15), dark: Color.Yellow.yellow500.opacity(0.2))

        static let ingredientTitle = Color(light: Color.Teal.teal1600, dark: Color.Teal.teal100)
        static let ingredientName = Color(light: Color.Teal.teal1400, dark: Color.Teal.teal200)
        static let ingredientReason = Color(light: Color.Gray.gray700, dark: Color.Teal.teal400)
        static let ingredientTypeBadge = Color(light: Color.Red.red500, dark: Color.Red.red500)

        static let nutritionLabel = Color(light: Color.Gray.gray700, dark: Color.Teal.teal400)
        static let nutritionValue = Color(light: Color.Teal.teal1600, dark: Color.Teal.teal100)
        static let nutritionDivider = Color(light: Color.Gray.gray300, dark: Color.Teal.teal1200)
        static let nutritionCardBackground = Color(light: Color.Teal.teal100, dark: Color.Teal.teal1500)

        static let summaryText = Color(light: Color.Teal.teal1600, dark: Color.Teal.teal200)
        static let summaryBackground = Color(light: Color.Teal.teal100, dark: Color.Teal.teal1500)
        static let summaryIcon = Color(light: Color.Teal.teal800, dark: Color.Teal.teal400)

        static let galleryButtonBackground = Color(light: Color.Teal.teal100, dark: Color.Teal.teal1500)
        static let galleryButtonIcon = Color(light: Color.Teal.teal1000, dark: Color.Teal.teal500)
        static let retakeButtonBackground = Color(light: Color.Gray.gray200, dark: Color.Teal.teal1300)
        static let retakeButtonText = Color(light: Color.Teal.teal1600, dark: Color.Teal.teal100)

        static let permissionTitle = Color(light: Color.Teal.teal1600, dark: Color.Teal.teal100)
        static let permissionSubtitle = Color(light: Color.Gray.gray700, dark: Color.Teal.teal400)
        static let permissionButton = Color(light: Color.Teal.teal1000, dark: Color.Teal.teal500)

        static let errorMessage = Color(light: Color.Red.red500, dark: Color.Red.red500)
    }
}
