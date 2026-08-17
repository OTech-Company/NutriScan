//
//  HelpScreen.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 30/07/2026.
//

import SwiftUI
import Shimmer

struct HelpScreen: View {
    @EnvironmentObject private var router: AppRouter
    @Environment(\.openURL) private var openURL

    @State private var viewModel: HelpViewModel

    init(viewModel: HelpViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color.HelperSemantic.background.ignoresSafeArea()

            VStack(spacing: 0) {
                SettingsHeaderSection(title: LocalizationKeys.Settings.help.localized, subtitle: nil) {
                    router.pop()
                }

                ScrollView(showsIndicators: false) {
                    VStack(
                        alignment: .leading,
                        spacing: HelperSemantics.Spacing.sectionVertical
                    ) {

                        // MARK: - FAQs Section
                        VStack(
                            alignment: .leading,
                            spacing: HelperSemantics.Spacing.itemSpacing
                        ) {
                            Text(LocalizationKeys.Settings.faqTitle.localized)
                                .font(Font.AppFont.subtitle1)
                                .foregroundColor(
                                    Color.HelperSemantic.sectionTitle)

                            if viewModel.isLoading {
                                ForEach(FaqItem.dummyItems) { item in
                                    FaqAccordionItem(
                                        item: item,
                                        isExpanded: false,
                                        onClick: {}
                                    )
                                    .redacted(reason: .placeholder)
                                    .shimmering()
                                }
                            } else {
                                ForEach(viewModel.faqItems) { item in
                                    FaqAccordionItem(
                                        item: item,
                                        isExpanded: viewModel.expandedFaqId
                                            == item.id,
                                        onClick: {
                                            viewModel.toggleFaq(id: item.id)
                                        }
                                    )
                                }
                            }
                        }

                        // MARK: - Contact Section
                        HelpContactSection {
                            if let mailURL = viewModel.getMailURL() {
                                openURL(mailURL) { accepted in
                                    if !accepted {
                                        viewModel.handleMailAppFailure()
                                    }
                                }
                            }
                        }

                        // MARK: - Credits Section
                        VStack(spacing: 4) {
                            Text(LocalizationKeys.Settings.madeWith.localized)
                                .font(Font.AppFont.textCaption)

                            let version =
                                Bundle.main.infoDictionary?[
                                    "CFBundleShortVersionString"] as? String
                                ?? "1.0.0"
                            Text("Version \(version)")
                                .font(Font.AppFont.textCaption)
                        }
                        .foregroundColor(Color.HelperSemantic.creditsText)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 12)

                    }
                    .padding(
                        .horizontal, HelperSemantics.Spacing.screenHorizontal
                    )
                    .padding(.vertical, HelperSemantics.Spacing.itemSpacing)
                    .padding(.bottom, 40)
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        .task {
            await viewModel.loadFaqs()
        }
        .customAlert(
            item: $viewModel.alert,
            config: { _ in
                CustomAlertConfig(
                        type: .warning,
                        title: LocalizationKeys.Settings.mailNotConfigured.localized,
                        message: LocalizationKeys.Settings.mailNotConfiguredDesc.localized,
                        primaryButton: CustomAlertButton(LocalizationKeys.Common.ok.localized)
                    )
            },
            primaryAction: { _ in }
        )
    }
}
