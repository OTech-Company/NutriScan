//
//  HelpScreen.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 30/07/2026.
//

import SwiftUI

struct HelpScreen: View {
    @EnvironmentObject private var router: AppRouter
    @Environment(\.openURL) private var openURL
    
    @State private var viewModel = HelpViewModel()
    
    var body: some View {
        ZStack {
            Color.HelperSemantic.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Ensure SettingsHeaderSection is imported or available in this scope
                SettingsHeaderSection(title: "Help", subtitle: nil){
                    router.pop()
                }
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: HelperSemantics.Spacing.sectionVertical) {
                        
                        // MARK: - FAQs Section
                        VStack(alignment: .leading, spacing: HelperSemantics.Spacing.itemSpacing) {
                            Text("Frequently Asked Questions")
                                .font(Font.AppFont.subtitle1)
                                .foregroundColor(Color.HelperSemantic.sectionTitle)
                            
                            if viewModel.isLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.top, 24)
                            } else {
                                ForEach(viewModel.faqItems) { item in
                                    FaqAccordionItem(
                                        item: item,
                                        isExpanded: viewModel.expandedFaqId == item.id,
                                        onClick: {
                                            viewModel.toggleFaq(id: item.id)
                                        }
                                    )
                                }
                            }
                        }
                        
                        // MARK: - Contact Section
                        HelpContactSection {
                            openEmailApp()
                        }
                        
                        // MARK: - Credits Section
                        VStack(spacing: 4) {
                            Text("Made with ❤️ by NutriScan Team")
                                .font(Font.AppFont.textCaption)
                            
                            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
                            Text("Version \(version)")
                                .font(Font.AppFont.textCaption)
                        }
                        .foregroundColor(Color.HelperSemantic.creditsText)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 12)
                        
                    }
                    .padding(.horizontal, HelperSemantics.Spacing.screenHorizontal)
                    .padding(.vertical, HelperSemantics.Spacing.itemSpacing)
                    .padding(.bottom, 40)
                }
            }
        }
        .task {
            await viewModel.loadFaqs()
        }
    }
    
    private func openEmailApp() {
        let subject = viewModel.emailSubject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let mailURL = URL(string: "mailto:\(viewModel.supportEmail)?subject=\(subject)") {
            openURL(mailURL)
        }
    }
}
