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
        return try await makeDecodableRequest(for: APIRouter.login(username: username, password: password))
    }
    
    func logout() async throws {
        return try await makeRequest(for: APIRouter.logout)
    }
    
    func forgotPassword(username: String) async throws {
        return try await makeRequest(for: APIRouter.logout)
    }
}


