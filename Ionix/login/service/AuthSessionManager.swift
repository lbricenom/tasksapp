//
//  SessionManager.swift
//  Ionix
//
//  Created by luis on 10/05/23.
//

import Foundation
import KeychainAccess

protocol AuthSessionManagerProtocol: AnyObject {
    var isLoggedIn: Bool { get set }
    var userProfile: UserProfile? { get set }
    func login(userProfile: UserProfile)
    func logout()
    func getCurrentRole() -> UserRole?
}

class AuthSessionManager: ObservableObject, AuthSessionManagerProtocol {
    private let keychain: Keychain
    private let tokenKey = "authToken"
    
    @Published var isLoggedIn = false
    var token: String? {
        get { keychain[tokenKey] }
        set { keychain[tokenKey] = newValue }
    }
    
    var userProfile: UserProfile? {
        didSet {
            guard let data = try? JSONEncoder().encode(userProfile) else { return }
            UserDefaults.standard.set(data, forKey: "userProfile")
        }
    }
    
    init() {
        keychain = Keychain(service: "com.ionix.taskManager.keychain")
        self.token = keychain[tokenKey]
        self.isLoggedIn = self.token != nil
        
        if let data = UserDefaults.standard.data(forKey: "userProfile") {
            self.userProfile = try? JSONDecoder().decode(UserProfile.self, from: data)
        }
    }
    
    func login(userProfile: UserProfile) {
        self.token = userProfile.token
        self.isLoggedIn = true
        self.userProfile = userProfile
    }
    
    func logout() {
        self.token = nil
        self.isLoggedIn = false
        self.userProfile = nil
        keychain[tokenKey] = nil
        UserDefaults.standard.removeObject(forKey: "userProfile")
    }
    
    func getCurrentRole() -> UserRole? {
        return self.userProfile?.role
    }
}
