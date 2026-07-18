//
//  SettingsView.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//

import SwiftUI

struct SettingsView: View {
    @State private var viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel = SettingsViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        Text("Settings")
            .navigationTitle("Settings")
    }
}
