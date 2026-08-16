//
//  Fonts.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/01/1448 AH.
//


import SwiftUI

extension Font {
    
    struct AppFont {
        private static var usesArabicFont: Bool {
            AppLanguage.current == .arabic
        }
        
        private static func appCustom(english: String, arabic: String, size: CGFloat) -> Font {
            Font.custom(usesArabicFont ? arabic : english, size: size)
        }
        
        static var title1: Font {
            appCustom(english: "PlusJakartaSans-Bold", arabic: "KOSans-Bold", size: 34)
        }
        static var title2: Font {
            appCustom(english: "PlusJakartaSans-Bold", arabic: "KOSans-Bold", size: 28)
        }
        static var title3: Font {
            appCustom(english: "PlusJakartaSans-SemiBold", arabic: "KOSans-SemiBold", size: 24)
        }
        static var title4: Font {
            appCustom(english: "PlusJakartaSans-SemiBold", arabic: "KOSans-SemiBold", size: 22)
        }
        
        static var subtitle1: Font {
            appCustom(english: "PlusJakartaSans-Medium", arabic: "KOSans-Medium", size: 20)
        }
        static var numbers: Font {
            appCustom(english: "PlusJakartaSans-Bold", arabic: "KOSans-Bold", size: 20)
        }
        static var subtitle2: Font {
            appCustom(english: "PlusJakartaSans-Medium", arabic: "KOSans-Medium", size: 18)
        }
        
        static var textPrimary: Font {
            appCustom(english: "LexendDeca-Medium", arabic: "KOSans-Medium", size: 16)
        }
        static var textDefault: Font {
            appCustom(english: "LexendDeca-Regular", arabic: "KOSans-Regular", size: 16)
        }
        static var textSecondary: Font {
            appCustom(english: "LexendDeca-Regular", arabic: "KOSans-Regular", size: 14)
        }
        static var textCaption: Font {
            appCustom(english: "LexendDeca-Light", arabic: "KOSans-Light", size: 12)
        }
        static var questrialRegular14: Font {
            appCustom(english: "Questrial-Regular", arabic: "KOSans-Regular", size: 14)
        }
        
        // History Row specific fonts
        static var plusJakartaSansSemiBold16: Font {
            appCustom(english: "PlusJakartaSans-SemiBold", arabic: "KOSans-SemiBold", size: 16)
        }
        static var lexendDecaRegular12: Font {
            appCustom(english: "LexendDeca-Regular", arabic: "KOSans-Regular", size: 12)
        }
        static var lexendDecaMedium11: Font {
            appCustom(english: "LexendDeca-Medium", arabic: "KOSans-Medium", size: 11)
        }
        
        // Forgot Password specific fonts
        static var plusJakartaSansBold28: Font {
            appCustom(english: "PlusJakartaSans-Bold", arabic: "KOSans-Bold", size: 28)
        }
        static var plusJakartaSansMedium16: Font {
            appCustom(english: "PlusJakartaSans-Medium", arabic: "KOSans-Medium", size: 16)
        }
        static var plusJakartaSansSemiBold18: Font {
            appCustom(english: "PlusJakartaSans-SemiBold", arabic: "KOSans-SemiBold", size: 18)
        }
        static var lexendDecaRegular12_FP: Font {
            appCustom(english: "LexendDeca-Regular", arabic: "KOSans-Regular", size: 12)
        }
        static var plusJakartaSansBold24: Font {
            appCustom(english: "PlusJakartaSans-Bold", arabic: "KOSans-Bold", size: 24)
        }
        static var lexendDecaMedium16: Font {
            appCustom(english: "LexendDeca-Medium", arabic: "KOSans-Medium", size: 16)
        }
        static var plusJakartaSansMedium18: Font {
            appCustom(english: "PlusJakartaSans-Medium", arabic: "KOSans-Medium", size: 18)
        }
        static var lexendDecaLight12: Font {
            appCustom(english: "LexendDeca-Light", arabic: "KOSans-Light", size: 12)
        }
        
        // Profile specific fonts
        static var lexendDecaLight10: Font {
            appCustom(english: "LexendDeca-Light", arabic: "KOSans-Light", size: 10)
        }
    }
}
