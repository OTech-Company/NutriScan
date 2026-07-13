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
    }
}
