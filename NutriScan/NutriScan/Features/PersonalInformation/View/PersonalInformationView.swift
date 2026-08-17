//
//  PersonalInformationView.swift
//  NutriScan
//
//  Created by Osama Hosam on 16/07/2026.
//

import SwiftUI

struct PersonalInformationView: View {
    @State private var viewModel: PersonalInformationViewModel
    
    init(viewModel: PersonalInformationViewModel = PersonalInformationViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        Text(LocalizationKeys.PersonalInformation.title.localized)
            .navigationTitle(LocalizationKeys.PersonalInformation.title.localized)
    }
}

#Preview {
    PersonalInformationView()
}
