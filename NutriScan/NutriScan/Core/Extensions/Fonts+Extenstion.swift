//
//  Fonts.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/01/1448 AH.
//


import SwiftUI

extension Font {
    
    struct AppFont {
        static let title1 = Font.custom("PlusJakartaSans-Bold", size: 34)
        static let title2 = Font.custom("PlusJakartaSans-Bold", size: 28)
        static let title3 = Font.custom("PlusJakartaSans-SemiBold", size: 24)
        static let title4 = Font.custom("PlusJakartaSans-SemiBold", size: 22)
        
        static let subtitle1 = Font.custom("PlusJakartaSans-Medium", size: 20)
        static let subtitle2 = Font.custom("PlusJakartaSans-Medium", size: 18)
        
        static let textPrimary = Font.custom("LexendDeca-Medium", size: 16)
        static let textDefault = Font.custom("LexendDeca-Regular", size: 16)
        static let textSecondary = Font.custom("LexendDeca-Regular", size: 14)
        static let textCaption = Font.custom("LexendDeca-Light", size: 12)
        static let questrialRegular14 = Font.custom("Questrial-Regular", size: 14)
        
        // History Row specific fonts
        static let plusJakartaSansSemiBold16 = Font.custom("PlusJakartaSans-SemiBold", size: 16)
        static let lexendDecaRegular12 = Font.custom("LexendDeca-Regular", size: 12)
        static let lexendDecaMedium11 = Font.custom("LexendDeca-Medium", size: 11)
        
        // Forgot Password specific fonts
        static let plusJakartaSansBold28 = Font.custom("PlusJakartaSans-Bold", size: 28)
        static let plusJakartaSansMedium16 = Font.custom("PlusJakartaSans-Medium", size: 16)
        static let plusJakartaSansSemiBold18 = Font.custom("PlusJakartaSans-SemiBold", size: 18)
        static let lexendDecaRegular12_FP = Font.custom("LexendDeca-Regular", size: 12) 
        static let plusJakartaSansBold24 = Font.custom("PlusJakartaSans-Bold", size: 24)
        static let lexendDecaMedium16 = Font.custom("LexendDeca-Medium", size: 16)
        static let plusJakartaSansMedium18 = Font.custom("PlusJakartaSans-Medium", size: 18)
        static let lexendDecaLight12 = Font.custom("LexendDeca-Light", size: 12)
    }
}
