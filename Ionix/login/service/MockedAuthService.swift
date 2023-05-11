//
//  MockedAuthService.swift
//  Ionix
//
//  Created by luis on 11/05/23.
//

import Foundation

class MockedAuthService: AuthServiceProtocol, JSONLoader {
    
    func login(username: String, password: String) async throws -> UserProfile {
        guard !username.isEmpty && !password.isEmpty else {
            let error = NSError(domain: "com.ionix.login.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Username and password cannot be empty"])
            throw error
        }
        let sanitizedUsername = username.removingSpecialCharacters()
        let sanitizedPassword = password.removingSpecialCharacters()
        
        if sanitizedUsername == "Admin" && sanitizedPassword == "admin" {
            return UserProfile(id: 99, username: "admin", email: "admin@example.com", role: .admin, token: "admin-token")
        }
    
        return UserProfile(id: 0, username: sanitizedUsername, email: "\(sanitizedUsername)@example.com", role: .executor, token: "executor-token")
    }
    
    func logout() async throws {
     
    }
    
    func forgotPassword(username: String) async throws {
        
    }
    
}
