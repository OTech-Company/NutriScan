import SwiftUI

struct TodayStepsScreen: View {
    @StateObject private var router = AppRouter()
    @StateObject private var viewModel: StepCounterViewModel

    init() {
        let repository: StepRepositoryProtocol = StepRepositoryImpl()
        let viewModel = StepCounterViewModel(
            observeStepsUseCase: ObserveDailyStepsUseCase(repository: repository),
            requestAuthUseCase: RequestStepAuthorizationUseCase(repository: repository),
            fetchHistoryUseCase: FetchStepsHistoryUseCase(repository: repository)
        )
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    init(viewModel: StepCounterViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    StepGaugeCardView(currentSteps: viewModel.todaySteps, goalSteps: 10_000)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            router.push(StepRoute.stepHistory(viewModel: viewModel))
                        }

                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(.custom("LexendDeca-Regular", size: 13))
                            .foregroundColor(Color.Red.red500)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                }
            }
            .navigationDestination(for: AnyRoute.self) { route in
                route.view()
            }
            .onAppear { viewModel.onAppear() }
            .onDisappear { viewModel.onDisappear() }
        }
        .environmentObject(router)
        .tint(Color.Teal.teal700)
    }
}

#Preview {
    TodayStepsScreen()
}
