//
//  CaloriesScreen.swift
//  NutriScan
//
//  Created by albaraa alsayed on 09/02/1448 AH.
//

import SwiftUI

struct CaloriesScreen: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator
    @State private var caloriesViewModel = CaloriesViewModel()
    @State private var stepViewModel: StepCounterViewModel
    
    // MARK: - Entrance Animation State
    @State private var showDailyProducts = false
    @State private var showCalorieGoals = false
    @State private var showStepsAndExercise = false
    @State private var showWater = false
    
    // MARK: - Alert State
    @State private var activeAlert: ActiveAlert = .none
    
    init() {
        let stepViewModel = StepCounterViewModel(
            observeStepsUseCase: DIContainer.shared.resolve(type: ObserveDailyStepsUseCase.self),
            requestAuthUseCase: DIContainer.shared.resolve(type: RequestStepAuthorizationUseCase.self),
            fetchHistoryUseCase: DIContainer.shared.resolve(type: FetchStepsHistoryUseCase.self)
        )
        _stepViewModel = State(wrappedValue: stepViewModel)
    }
    
    init(stepViewModel: StepCounterViewModel) {
        _stepViewModel = State(wrappedValue: stepViewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // MARK: Daily Products
                DailyProductsSection(
                    dailyKcal: caloriesViewModel.dailyKcal,
                    onAddFoodTap: {
                        flowCoordinator.selectedTab = .bookmark
                    }
                )
                .opacity(showDailyProducts ? 1 : 0)
                .offset(y: showDailyProducts ? 0 : 30)
                
                // MARK: Calorie Goals
                CalorieGoalsSection(
                    currentTdee: caloriesViewModel.currentTdee,
                    maxTdee: caloriesViewModel.maxTdee
                )
                .opacity(showCalorieGoals ? 1 : 0)
                .offset(y: showCalorieGoals ? 0 : 30)
                
                // MARK: Steps + Exercise (side by side)
                HStack(spacing: 12) {
                    StepGaugeCardView(
                        currentSteps: stepViewModel.todaySteps,
                        goalSteps: 10_000
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        router.push(CaloriesRoute.stepHistory(viewModel: stepViewModel))
                    }
                    
                    ExerciseCardView(
                        exerciseKcal: caloriesViewModel.exerciseKcal,
                        exerciseMinutes: caloriesViewModel.exerciseMinutes,
                        onAddTap: { caloriesViewModel.addExercise() }
                    )
                }
                .opacity(showStepsAndExercise ? 1 : 0)
                .offset(y: showStepsAndExercise ? 0 : 30)
                
                // MARK: Water Tracking
                WaterTrackingSection(
                    currentGlasses: caloriesViewModel.waterCurrent,
                    goalGlasses: caloriesViewModel.waterGoal,
                    onAddTap: { caloriesViewModel.addWater() }
                )
                .opacity(showWater ? 1 : 0)
                .offset(y: showWater ? 0 : 30)
            }
            .padding(22)
        }
        .background(Color.CaloriesSemantic.background)
        .onAppear {
            caloriesViewModel.onAppear()
            stepViewModel.onAppear()
            triggerEntranceAnimations()
            if stepViewModel.errorMessage != nil {
                activeAlert = .warning
            }
        }
        .onDisappear {
            stepViewModel.onDisappear()
        }
        .onChange(of: stepViewModel.errorMessage) { _, error in
            if error != nil {
                activeAlert = .warning
            }
        }
        .customAlert(activeAlert: $activeAlert, config: { alert in
            switch alert {
            case .warning, .error:
                return CustomAlertConfig(
                    type: .warning,
                    title: "Motion & Fitness",
                    description: stepViewModel.errorMessage ?? "Permission required",
                    primaryButtonTitle: "OK",
                    primaryButtonColor: Color.Teal.teal1000
                )
            default:
                return CustomAlertConfig(
                    type: .warning,
                    title: "Notice",
                    description: stepViewModel.errorMessage ?? ""
                )
            }
        }, primaryAction: { _ in
            activeAlert = .none
        })
    }
    
    // MARK: - Staggered Entrance
    
    private func triggerEntranceAnimations() {
        let spring = Animation.spring(response: 0.6, dampingFraction: 0.75)
        
        withAnimation(spring.delay(0.1)) {
            showDailyProducts = true
        }
        withAnimation(spring.delay(0.2)) {
            showCalorieGoals = true
        }
        withAnimation(spring.delay(0.35)) {
            showStepsAndExercise = true
        }
        withAnimation(spring.delay(0.5)) {
            showWater = true
        }
    }
}

#Preview("Light") {
    CaloriesScreen()
        .environmentObject(AppRouter())
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    CaloriesScreen()
        .environmentObject(AppRouter())
        .preferredColorScheme(.dark)
}
