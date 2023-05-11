//
//  LoginViewModel.swift
//  Ionix
//
//  Created by luis on 10/05/23.
//
import Foundation
import Combine

class LoginViewModel: ObservableObject {
    private let authService: AuthServiceProtocol
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoggingIn: Bool = false
    @Published var isShowingAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var loginResult: Result<UserProfile, Error>?
    @Published var isPasswordResetSent: Bool = false
    
    private var cancellables: [AnyCancellable] = []
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func login() async {
        DispatchQueue.main.async {
            self.isLoggingIn = true
        }
        do {
            let userProfile = try await authService.login(username: username, password: password)
            
            DispatchQueue.main.async {
                self.loginResult = .success(userProfile)
            }
        } catch {
            DispatchQueue.main.async {
                self.loginResult = .failure(error)
            }
            
        }
        DispatchQueue.main.async {
            self.isLoggingIn = false
        }
    }
    
    func logout() {
//        authService.logout()
    }
    
    func forgotPassword() async throws {
        guard !username.isEmpty else {
            let error = NSError(domain: "com.ionix.forgotpassword.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Username cannot be empty"])
            throw error
        }

        try await authService.forgotPassword(username: username)
    }
}
