//
//  MockedAuthService.swift
//  Ionix
//
//  Created by luis on 11/05/23.
//

import Foundation

class MockedAuthService: AuthServiceProtocol, JSONLoader {
    
    func login(username: String, password: String) async throws -> UserProfile {
        if username == "Admin" && password == "admin" {
            return UserProfile(id: 99, username: "admin", email: "admin@example.com", role: .admin, token: "admin-token")
        }
    
        return UserProfile(id: 0, username: username, email: "\(password)@example.com", role: .executor, token: "executor-token")
    }
    
    func logout() async throws {
     
    }
    
    func forgotPassword(username: String) async throws {
        
    }
    
}
