//
//  FaqItem.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 30/07/2026.
//

import Foundation

struct FaqItem: Identifiable, Equatable {
    let id: Int
    let question: String
    let answer: String
}

extension FaqItem {
    static let dummyItems: [FaqItem] = [
        FaqItem(id: -1, question: "How do I scan a product correctly in NutriScan?", answer: ""),
        FaqItem(id: -2, question: "What is NutriGPT and how does it analyze my food?", answer: ""),
        FaqItem(id: -3, question: "How do I add a family member to my account?", answer: ""),
        FaqItem(id: -4, question: "Where is my scan history located in profile?", answer: ""),
        FaqItem(id: -5, question: "How to edit my profile details easily?", answer: "")
    ]
}
