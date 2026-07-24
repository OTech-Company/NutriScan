//
//  RAGFlowView.swift
//  NutriScan
//

import SwiftUI

struct RAGFlowView: View {
    @StateObject private var router = AppRouter()
    @State private var viewModel: RAGChatViewModel

    init() {
        let repository = RAGRepositoryImpl()
        let useCase = QueryRAGUseCaseImpl(repository: repository)
        self._viewModel = State(wrappedValue: RAGChatViewModel(queryUseCase: useCase))
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            RAGChatView(viewModel: viewModel)
                .navigationDestination(for: AnyRoute.self) { route in
                    route.view()
                }
        }
        .environmentObject(router)
    }
}
