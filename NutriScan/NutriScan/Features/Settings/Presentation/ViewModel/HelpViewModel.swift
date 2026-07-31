//
//  HelpViewModel.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 30/07/2026.
//

import Foundation
import SwiftUI
import UIKit

@MainActor
@Observable
final class HelpViewModel {
    var faqItems: [FaqItem] = []
    var expandedFaqId: Int? = nil
    var isLoading: Bool = false
    var activeAlert: ActiveAlert = .none
    
    private let getFaqUseCase: GetFaqUseCaseProtocol
    let supportEmail = "minawagdy2228@gmail.com"
    let emailSubject = "NutriScan Support Request"
    
    init(
        getFaqUseCase: GetFaqUseCaseProtocol
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
        expandedFaqId = (expandedFaqId == id) ? nil : id
    }
    
    // MARK: - Support Logic
    
    /// Constructs and formats the URL for the mail app
    func getMailURL() -> URL? {
        let subject = emailSubject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "mailto:\(supportEmail)?subject=\(subject)")
    }
    
    /// Handles the fallback logic if the device cannot open a mail app
    func handleMailAppFailure() {
        UIPasteboard.general.string = supportEmail
        activeAlert = .warning
    }
}
