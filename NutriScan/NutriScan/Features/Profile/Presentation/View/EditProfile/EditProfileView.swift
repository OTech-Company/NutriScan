//
//  EditProfileView.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//

import SwiftUI

struct EditProfileView: View {
    @State private var viewModel: EditProfileViewModel
    
    init(viewModel: EditProfileViewModel = EditProfileViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        Text("Edit Profile")
            .navigationTitle("Edit Profile")
    }
}
