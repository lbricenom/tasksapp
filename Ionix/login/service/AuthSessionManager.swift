//
//  SessionManager.swift
//  Ionix
//
//  Created by luis on 10/05/23.
//

import Foundation

protocol AuthSessionManagerProtocol: AnyObject {
    var isLoggedIn: Bool { get set }
    var userProfile: UserProfile? { get set }
    func login(userProfile: UserProfile)
    func logout()
    func getCurrentRole() -> UserRole?
}

class AuthSessionManager: ObservableObject, AuthSessionManagerProtocol {

    
    @Published var isLoggedIn = false
    var token: String? {
        didSet {
            UserDefaults.standard.set(token, forKey: "token")
        }
    }
    
    var userProfile: UserProfile? {
        didSet {
            guard let data = try? JSONEncoder().encode(userProfile) else { return }
            UserDefaults.standard.set(data, forKey: "userProfile")
        }
    }
    
    init() {
        self.token = UserDefaults.standard.string(forKey: "token")
        self.isLoggedIn = self.token != nil
        
        if let data = UserDefaults.standard.data(forKey: "userProfile") {
            self.userProfile = try? JSONDecoder().decode(UserProfile.self, from: data)
        }
    }
    
    func login( userProfile: UserProfile) {
        self.token = userProfile.token
        self.isLoggedIn = true
        self.userProfile = userProfile
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
    }
    
    func logout() {
        self.token = nil
        self.isLoggedIn = false
        self.userProfile = nil
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "userProfile")
    }
    
    func getCurrentRole() -> UserRole? {
        return self.userProfile?.role
    }
}
