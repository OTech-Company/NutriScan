//
//  HelpViewModel.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 30/07/2026.
//

import Foundation
import SwiftUI

@Observable
final class HelpViewModel {
    var faqItems: [FaqItem] = []
    var expandedFaqId: Int? = nil
    var isLoading: Bool = false
    
    private let getFaqUseCase: GetFaqUseCaseProtocol
    let supportEmail = "minawagdy2228@gmail.com"
    let emailSubject = "NutriScan Support Request"
    
    // Injecting via your DIContainer
    init(
        getFaqUseCase: GetFaqUseCaseProtocol = DIContainer.shared.resolve(type: GetFaqUseCaseProtocol.self)
    ) {
        self.getFaqUseCase = getFaqUseCase
    }
    
    @MainActor
    func loadFaqs() async {
        isLoading = true
        do {
            self.faqItems = try await getFaqUseCase.execute()
        } catch {
            print("Failed to load FAQs: \(error)")
        }
        isLoading = false
    }
    
    func toggleFaq(id: Int) {
        if expandedFaqId == id {
            expandedFaqId = nil
        } else {
            expandedFaqId = id
        }
    }
}
