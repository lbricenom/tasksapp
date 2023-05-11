//
//  AuthService.swift
//  Ionix
//
//  Created by luis on 10/05/23.
//

import Foundation
import Alamofire


struct LoginResult: Codable {
    let token: String
    let userProfile: UserProfile
}

protocol AuthServiceProtocol: NetworkRequestable {
    func login(username: String, password: String) async throws -> UserProfile
    func logout() async throws
    func forgotPassword(username: String) async throws
}

class AuthServiceImpl: AuthServiceProtocol {
    
    func login(username: String, password: String) async throws -> UserProfile {
        guard !username.isEmpty && !password.isEmpty else {
            let error = NSError(domain: "com.ionix.login.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Username and password cannot be empty"])
            throw error
        }
        
        let sanitizedUsername = username.removingSpecialCharacters()
        let sanitizedPassword = password.removingSpecialCharacters()
        return try await makeDecodableRequest(for: APIRouter.login(username: sanitizedUsername, password: sanitizedPassword))
    }
    
    func logout() async throws {
        return try await makeRequest(for: APIRouter.logout)
    }
    
    func forgotPassword(username: String) async throws {
        return try await makeRequest(for: APIRouter.logout)
    }
}


