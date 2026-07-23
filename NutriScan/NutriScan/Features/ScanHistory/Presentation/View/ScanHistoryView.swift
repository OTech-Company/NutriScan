//
//  ScanHistoryView.swift
//  NutriScan
//
//  Created by Osama Hosam on 16/07/2026.
//

import SwiftUI

struct ScanHistoryView: View {
    @State private var viewModel: ScanHistoryViewModel
    
    init(viewModel: ScanHistoryViewModel = ScanHistoryViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        Text("Scan History")
            .navigationTitle("Scan History")
    }
}
