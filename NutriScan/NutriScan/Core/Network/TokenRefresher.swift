//
//  TokenRefresher.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 22/07/2026.
//

import Foundation

actor TokenRefresher {
    static let shared = TokenRefresher()
    
    private var refreshTask: Task<String, Error>?
    
    private init() {}
    
    /// Thread-safely refreshes the access token using the stored refresh_token.
    /// Returns the new access token string on success.
    /// Concurrent callers will wait on the same in-flight refresh task.
    func refreshToken() async throws -> String {
        if let existingTask = refreshTask {
            return try await existingTask.value
        }
        
        let task = Task<String, Error> {
            defer {
                Task { [weak self] in
                    await self?.clearTask()
                }
            }
            
            guard let storedRefreshToken = try? KeychainManager.shared.get(key: .refreshToken),
                  !storedRefreshToken.isEmpty else {
                await self.handleSessionExpiration()
                throw NetworkError.unauthorized
            }
            
            let dto = RefreshTokenRequestDTO(refreshToken: storedRefreshToken)
            let endpoint = AuthEndpoint.refreshToken(dto)
            
            do {
                let responseDTO: LoginResponseDTO = try await NetworkService.shared.request(endpoint, isRetry: true)
                
                try KeychainManager.shared.save(key: .accessToken, value: responseDTO.accessToken)
                try KeychainManager.shared.save(key: .refreshToken, value: responseDTO.refreshToken)
                
                return responseDTO.accessToken
            } catch {
                await self.handleSessionExpiration()
                throw error
            }
        }
        
        self.refreshTask = task
        return try await task.value
    }
    
    private func clearTask() {
        self.refreshTask = nil
    }
    
    private func handleSessionExpiration() async {
        try? KeychainManager.shared.delete(key: .accessToken)
        try? KeychainManager.shared.delete(key: .refreshToken)
        
        await MainActor.run {
            NotificationCenter.default.post(name: .userDidSessionExpire, object: nil)
        }
    }
}
