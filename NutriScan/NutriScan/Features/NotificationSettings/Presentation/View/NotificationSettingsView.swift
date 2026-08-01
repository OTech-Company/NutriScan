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
                    
                // MARK: - Notification Types Section
                SectionHeader(title: "Notification Types")
                    
                ForEach(NotificationCategory.allCases) { category in
                    NotificationToggleRow(
                        category: category,
                        isOn: Binding(
                            get: { viewModel.toggleStates[category] ?? true },
                            set: { newValue in viewModel.toggleCategory(category, isOn: newValue) }
                        )
                    )
                }
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
