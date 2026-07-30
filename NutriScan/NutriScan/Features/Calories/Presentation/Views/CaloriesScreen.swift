//
//  CaloriesScreen.swift
//  NutriScan
//
//  Created by albaraa alsayed on 09/02/1448 AH.
//

import SwiftUI

struct CaloriesScreen: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator
    @State private var caloriesViewModel = CaloriesViewModel()
    @State private var stepViewModel: StepCounterViewModel

    @State private var showDailyProducts = false
    @State private var showCalorieGoals = false
    @State private var showStepsAndExercise = false
    @State private var showWater = false

    @State private var activeAlert: ActiveAlert = .none

    @State private var mealRemovalRequest: MealRemovalRequest? = nil
    @State private var unfillCupIndex: Int? = nil
    @State private var deleteTargetCupRequested = false
    @State private var stepPersistenceTask: Task<Void, Never>?

    init() {
        let stepViewModel = StepCounterViewModel(
            observeStepsUseCase: DIContainer.shared.resolve(type: ObserveDailyStepsUseCase.self),
            requestAuthUseCase: DIContainer.shared.resolve(type: RequestStepAuthorizationUseCase.self),
            fetchHistoryUseCase: DIContainer.shared.resolve(type: FetchStepsHistoryUseCase.self)
        )
        _stepViewModel = State(initialValue: stepViewModel)
    }

    init(stepViewModel: StepCounterViewModel) {
        _stepViewModel = State(initialValue: stepViewModel)
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 24) {

                    DailyProductsSection(
                        dailyKcal: caloriesViewModel.dailyKcal,
                        meals: caloriesViewModel.meals,
                        onAddFoodTap: {
                            flowCoordinator.selectedTab = .bookmark
                        },
                        onRemoveMealRequest: { request in
                            mealRemovalRequest = request
                        }
                    )
                    .opacity(showDailyProducts ? 1 : 0)
                    .offset(y: showDailyProducts ? 0 : 30)

                    CalorieGoalsSection(
                        mealCalories: caloriesViewModel.dailyKcal,
                        targetCalories: caloriesViewModel.calorieGoal,
                        caloriesBurned: caloriesViewModel.totalBurnedKcal,
                        onCompleteProfileTap: {
                            router.push(ProfileRoute.personalInformation)
                        }
                    )
                    .opacity(showCalorieGoals ? 1 : 0)
                    .offset(y: showCalorieGoals ? 0 : 30)

                    HStack(spacing: 12) {
                        StepGaugeCardView(
                            currentSteps: stepViewModel.todaySteps,
                            goalSteps: 10_000,
                            onTap: {
                                router.push(CaloriesRoute.stepHistory(viewModel: stepViewModel))
                            }
                        )

                        ExerciseCardView(
                            exerciseKcal: caloriesViewModel.exerciseKcal,
                            exerciseMinutes: caloriesViewModel.exerciseMinutes,
                            onAddTap: {
                                router.push(CaloriesRoute.exercises)
                            }
                        )
                    }
                    .opacity(showStepsAndExercise ? 1 : 0)
                    .offset(y: showStepsAndExercise ? 0 : 30)

                    WaterTrackingSection(
                        currentGlasses: caloriesViewModel.waterCurrent,
                        goalGlasses: caloriesViewModel.waterGoal,
                        isUpdating: caloriesViewModel.isUpdatingWater,
                        onAddTargetCupTap: {
                            caloriesViewModel.addTargetCup()
                        },
                        onFillCup: { index in
                            caloriesViewModel.fillCup(index: index)
                        },
                        onUnfillCupRequest: { index in
                            unfillCupIndex = index
                        },
                        onDeleteTargetCupRequest: {
                            deleteTargetCupRequested = true
                        }
                    )
                    .opacity(showWater ? 1 : 0)
                    .offset(y: showWater ? 0 : 30)
                }
                .padding(22)
            }
            .refreshable {
                await caloriesViewModel.fetchTodayTracking()
            }

            if caloriesViewModel.isLoading {
                ZStack {
                    Color.CaloriesSemantic.background.opacity(0.6)
                        .ignoresSafeArea()
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(Color.Teal.teal1000)
                        .scaleEffect(1.4)
                }
                .transition(.opacity)
            }
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
            stepPersistenceTask?.cancel()
            persistCurrentSteps()
            stepViewModel.onDisappear()
        }
        .onChange(of: stepViewModel.todaySteps) { _, _ in
            stepPersistenceTask?.cancel()
            stepPersistenceTask = Task {
                try? await Task.sleep(for: .seconds(5))
                guard !Task.isCancelled else { return }
                persistCurrentSteps()
            }
        }
        .onChange(of: scenePhase) { _, phase in
            guard phase != .active else { return }
            stepPersistenceTask?.cancel()
            persistCurrentSteps()
        }
        .onChange(of: stepViewModel.errorMessage) { _, error in
            if error != nil {
                activeAlert = .warning
            }
        }
        .onChange(of: caloriesViewModel.errorMessage) { _, error in
            if error != nil {
                activeAlert = .error
            }
        }
        .customAlert(activeAlert: $activeAlert, config: { alert in
            switch alert {
            case .warning:
                return CustomAlertConfig(
                    type: .warning,
                    title: "Motion & Fitness",
                    description: stepViewModel.errorMessage ?? "Permission required",
                    primaryButtonTitle: "OK",
                    primaryButtonColor: Color.Teal.teal1000
                )
            case .error:
                return CustomAlertConfig(
                    type: .warning,
                    title: "Something went wrong",
                    description: caloriesViewModel.errorMessage ?? "Please try again.",
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
            caloriesViewModel.dismissError()
            activeAlert = .none
        })
        .customAlert(
            isPresented: Binding(
                get: { mealRemovalRequest != nil },
                set: { if !$0 { mealRemovalRequest = nil } }
            ),
            type: .delete,
            title: mealRemovalRequest?.kind == .one ? "Remove One Serving?" : "Remove Meal?",
            description: mealRemovalRequest?.kind == .one
                ? "One serving will be removed from today's log."
                : "All servings of this meal will be removed from today's log.",
            primaryButtonTitle: "Remove",
            primaryButtonColor: Color.red,
            primaryAction: {
                if let request = mealRemovalRequest {
                    switch request.kind {
                    case .one:
                        caloriesViewModel.removeOneMeal(scanId: request.meal.scanId)
                    case .all:
                        caloriesViewModel.deleteMeal(scanId: request.meal.scanId)
                    }
                }
                mealRemovalRequest = nil
            },
            secondaryButtonTitle: "Cancel",
            secondaryAction: { mealRemovalRequest = nil }
        )
        .customAlert(
            isPresented: Binding(
                get: { unfillCupIndex != nil },
                set: { if !$0 { unfillCupIndex = nil } }
            ),
            type: .delete,
            title: "Remove Water?",
            description: "Do you want to mark this cup as undrunk?",
            primaryButtonTitle: "Remove",
            primaryButtonColor: Color.red,
            primaryAction: {
                if let idx = unfillCupIndex {
                    _ = idx
                    caloriesViewModel.removeConsumedCup()
                }
                unfillCupIndex = nil
            },
            secondaryButtonTitle: "Cancel",
            secondaryAction: { unfillCupIndex = nil }
        )
        .customAlert(
            isPresented: $deleteTargetCupRequested,
            type: .delete,
            title: "Remove Target Cup?",
            description: "This will reduce your daily water goal by 1 cup.",
            primaryButtonTitle: "Remove",
            primaryButtonColor: Color.red,
            primaryAction: { 
                caloriesViewModel.removeTargetCup()
                deleteTargetCupRequested = false
            },
            secondaryButtonTitle: "Cancel",
            secondaryAction: { deleteTargetCupRequested = false }
        )
    }

    private func triggerEntranceAnimations() {
        let spring = Animation.spring(response: 0.6, dampingFraction: 0.75)

        withAnimation(spring.delay(0.1)) { showDailyProducts = true }
        withAnimation(spring.delay(0.2)) { showCalorieGoals = true }
        withAnimation(spring.delay(0.35)) { showStepsAndExercise = true }
        withAnimation(spring.delay(0.5)) { showWater = true }
    }

    private func persistCurrentSteps() {
        let analytics = stepViewModel.todayAnalytics()
        caloriesViewModel.updateSteps(
            stepViewModel.todaySteps,
            calories: analytics.caloriesBurned
        )
    }
}

#Preview("Light") {
    CaloriesScreen()
        .environmentObject(AppRouter())
        .environmentObject(AppFlowCoordinator())
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    CaloriesScreen()
        .environmentObject(AppRouter())
        .environmentObject(AppFlowCoordinator())
        .preferredColorScheme(.dark)
}
