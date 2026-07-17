//
//  GenderSelectionViewModel.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 17/07/2026.
//

import Foundation
import Observation

@Observable
final class GenderSelectionViewModel {
    var selectedGender: Gender = .male   // Male selected by default

    let currentStep: Int = 1
    let totalSteps: Int = 4

    // TODO: persist selectedGender via ProfileUseCase once backend integration lands
}
