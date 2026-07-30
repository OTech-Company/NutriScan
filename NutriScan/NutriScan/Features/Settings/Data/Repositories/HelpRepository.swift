//
//  HelpRepository.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 30/07/2026.
//

import Foundation

final class HelpRepository: HelpRepositoryProtocol {
    func getFaqs() async throws -> [FaqItem] {
        // Simulating a fast network fetch to enforce asynchronous UI handling
        try await Task.sleep(nanoseconds: 300_000_000)
        
        return [
            FaqItem(id: 1, question: "How do I scan a product?", answer: "Hold your camera steady over the barcode until the scanner detects it automatically."),
            FaqItem(id: 2, question: "How do I read a receipt?", answer: "Go to the scan tab and select 'Receipt'. Take a clear picture of your receipt in good lighting."),
            FaqItem(id: 3, question: "What is NutriGPT?", answer: "NutriGPT is your personal AI assistant that helps analyze your nutritional intake and answers health-related questions."),
            FaqItem(id: 4, question: "How do I log my meals?", answer: "Navigate to the daily log section and tap the '+' button to add items manually or via scanning."),
            FaqItem(id: 5, question: "How do I add a family member?", answer: "Go to Profile Settings, scroll to Family Members, and tap 'Add Member'."),
            FaqItem(id: 6, question: "Where is my scan history?", answer: "Your scan history is located on your Profile dashboard under 'Scan History'."),
            FaqItem(id: 7, question: "How do I read news?", answer: "The Home tab features a daily feed of health and nutrition news tailored for you."),
            FaqItem(id: 8, question: "How to edit my profile?", answer: "Go to Profile Settings and tap the edit icon next to your avatar to change your personal details."),
            FaqItem(id: 9, question: "How do you protect my privacy?", answer: "We use end-to-end encryption and never sell your personal health data to third parties."),
            FaqItem(id: 10, question: "How do I change app appearance?", answer: "Navigate to App Settings and use the Appearance toggle to switch between Light, Dark, and System modes.")
        ]
    }
}
