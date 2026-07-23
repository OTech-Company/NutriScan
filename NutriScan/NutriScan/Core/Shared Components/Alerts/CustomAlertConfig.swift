//
//  CustomAlertConfig.swift
//  NutriScan
//
//  Created by albaraa alsayed on 23/07/2026.
//

import SwiftUI

struct CustomAlertConfig: Sendable {
    let type: CustomAlertType
    let title: String
    let description: String
    let primaryButtonTitle: String
    let primaryButtonColor: Color
    let secondaryButtonTitle: String?
    
    init(
        type: CustomAlertType,
        title: String,
        description: String,
        primaryButtonTitle: String = "OK",
        primaryButtonColor: Color = Color.Teal.teal1000,
        secondaryButtonTitle: String? = nil
    ) {
        self.type = type
        self.title = title
        self.description = description
        self.primaryButtonTitle = primaryButtonTitle
        self.primaryButtonColor = primaryButtonColor
        self.secondaryButtonTitle = secondaryButtonTitle
    }
}
