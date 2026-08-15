//
//  NotificationSettingsView.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//

import SwiftUI

struct NotificationSettingsView: View {
    
    @State var viewModel: NotificationSettingsViewModel
    @EnvironmentObject private var router: AppRouter

    var body: some View {
            
        VStack(spacing: 0) {
                
            SettingsHeaderSection(title: "Notification Settings", subtitle: nil) {
                router.pop()
            }

            ScrollView(showsIndicators: false) {

                LazyVStack(spacing: 12) {

                    // Category Sections
                    ForEach(NotificationSection.allCases, id: \.rawValue) { section in
                        let categories = NotificationCategory.allCases.filter { $0.section == section }

                        // Section header
                        SectionHeader(title: section.rawValue)

                        // Rows for this section
                        ForEach(categories) { category in
                            NotificationToggleRow(
                                category: category,
                                isOn: Binding(
                                    get: { viewModel.toggleStates[category] ?? true },
                                    set: { newValue in viewModel.toggleCategory(category, isOn: newValue) }
                                )
                            )
                        }
                    }
                    
                    // Quiet Hours Section
                    SectionHeader(title: "Quiet Hours")

                    QuietHoursToggleRow(
                        timeRangeText: viewModel.quietHoursTimeString,
                        isOn: Binding(
                            get: { viewModel.isQuietHoursEnabled },
                            set: { newValue in viewModel.toggleQuietHours(isOn: newValue) }
                        )
                    )

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
      }
      .background(Color.NotificationSemantic.screenBackground.ignoresSafeArea())
      .navigationBarHidden(true)
      .ignoresSafeArea(edges: .top)
      .onAppear {
         viewModel.loadPreferences()
      }
   }
}
