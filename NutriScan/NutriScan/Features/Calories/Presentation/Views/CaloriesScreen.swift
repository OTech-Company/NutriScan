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
    @State private var caloriesViewModel = CaloriesFactory.makeCaloriesViewModel()
    @State private var stepViewModel: StepCounterViewModel

    @State private var showDailyProducts = false
    @State private var showCalorieGoals = false
    @State private var showStepsAndExercise = false
    @State private var showWater = false

    @State private var activeAlert: ActiveAlert = .none

    @State private var mealRemovalRequest: MealRemovalRequest? = nil
    @State private var showMealRemovalConfirmation = false
    @State private var unfillCupIndex: Int? = nil
    @State private var showWaterRemovalConfirmation = false
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
            TopSafeAreaScrollView(
                background: Color.CaloriesSemantic.background,
                refreshAction: {
                    await handleActivation()
                },
                topBar: { _ in
                    DailyProductsHeader(dailyKcal: caloriesViewModel.dailyKcal)
                        .padding(.horizontal, 22)
                        .frame(height: 60)
                        .accessibilityIdentifier("calories.topBar")
                }
            ) {
                VStack(spacing: 0) {
                    VStack(spacing: 24) {

                        DailyProductsSection(
                            dailyKcal: caloriesViewModel.dailyKcal,
                            meals: caloriesViewModel.meals,
                            mutatingMealIDs: caloriesViewModel.mutatingMealIDs,
                            showsHeader: false,
                            onAddFoodTap: {
                                flowCoordinator.selectedTab = .bookmark
                            },
                            onRemoveMealRequest: { request in
                                mealRemovalRequest = request
                                showMealRemovalConfirmation = true
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
                                exerciseKcal: Int(caloriesViewModel.exerciseKcal.rounded()),
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
                                showWaterRemovalConfirmation = true
                            },
                            onDeleteTargetCupRequest: {
                                deleteTargetCupRequested = true
                            }
                        )
                        .opacity(showWater ? 1 : 0)
                        .offset(y: showWater ? 0 : 30)
                    }
                    .padding(22)

                    Spacer(minLength: CustomAnimatedTabBar.contentClearance)
                }
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
        .onAppear {
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
            if phase == .active {
                Task { await handleActivation() }
            } else {
                stepPersistenceTask?.cancel()
                persistCurrentSteps()
            }
        }
        .onChange(of: flowCoordinator.selectedTab) { _, selectedTab in
            guard selectedTab == .calories else { return }
            Task { await handleActivation() }
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
        .onReceive(NotificationCenter.default.publisher(for: .NSCalendarDayChanged)) { _ in
            Task { await handleActivation() }
        }
        .task {
            await handleActivation()
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
            isPresented: $showMealRemovalConfirmation,
            type: .delete,
            title: mealRemovalRequest?.kind == .one ? "Remove One Serving?" : "Remove Meal?",
            description: mealRemovalRequest?.kind == .one
                ? "One serving will be removed from today's log."
                : "All servings of this meal will be removed from today's log.",
            primaryButtonTitle: "Remove",
            primaryButtonColor: Color.red,
            primaryAction: {
                if let request = mealRemovalRequest {
                    Task {
                        switch request.kind {
                        case .one:
                            await caloriesViewModel.removeOneMeal(scanId: request.meal.scanId)
                        case .all:
                            await caloriesViewModel.deleteMeal(scanId: request.meal.scanId)
                        }
                    }
                }
                mealRemovalRequest = nil
                showMealRemovalConfirmation = false
            },
            secondaryButtonTitle: "Cancel",
            secondaryAction: {
                mealRemovalRequest = nil
                showMealRemovalConfirmation = false
            }
        )
        .customAlert(
            isPresented: $showWaterRemovalConfirmation,
            type: .delete,
            title: "Remove Water?",
            description: "Do you want to mark this cup as undrunk?",
            primaryButtonTitle: "Remove",
            primaryButtonColor: Color.red,
            primaryAction: {
                if unfillCupIndex != nil {
                    caloriesViewModel.removeConsumedCup()
                }
                unfillCupIndex = nil
                showWaterRemovalConfirmation = false
            },
            secondaryButtonTitle: "Cancel",
            secondaryAction: {
                unfillCupIndex = nil
                showWaterRemovalConfirmation = false
            }
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
        persistCurrentSteps(for: caloriesViewModel.loadedDate)
    }

    private func persistCurrentSteps(for date: String?) {
        guard stepViewModel.isAuthorized else { return }
        let analytics = stepViewModel.todayAnalytics()
        if let date {
            caloriesViewModel.updateSteps(
                stepViewModel.todaySteps,
                calories: analytics.caloriesBurned,
                for: date
            )
        } else {
            caloriesViewModel.updateSteps(
                stepViewModel.todaySteps,
                calories: analytics.caloriesBurned
            )
        }
    }

    private func handleActivation() async {
        if caloriesViewModel.needsDayRollover {
            persistCurrentSteps(for: caloriesViewModel.loadedDate)
            stepPersistenceTask?.cancel()
            stepViewModel.rolloverToCurrentDay()
        }
        await caloriesViewModel.activate()
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
