//
//  ContentView.swift
//  Ionix
//
//  Created by luis on 10/05/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var sessionManager = AuthSessionManager()
    @State private var isPresentingLogin = false
    //Using mocked services as we dont have a concrete backend implementation, although the real services are implemented.
    private let loginViewModel = LoginViewModel(authService: MockedAuthService())
    private let taskViewModel = TaskViewModel(taskService: MockedRemoteTaskService())

    var body: some View {
        Group {
            if sessionManager.isLoggedIn {
                
                
                TabView {
                    if let currentUserRole = sessionManager.getCurrentRole() {
                        switch currentUserRole {
                        case .admin:
                            AdminView(taskManager: taskViewModel)
                                .environmentObject(sessionManager)
                                .tabItem {
                                    Label("Tasks", systemImage: "list.bullet")
                                }
                            
                        case .executor:
                            ExecutorView(taskManager: taskViewModel)
                                .environmentObject(sessionManager)
                                .tabItem {
                                    Label("Tasks", systemImage: "list.bullet")
                                }
                            
                        }
                    }
                        
                    ProfileView()
                        .environmentObject(sessionManager)
                        .tabItem {
                            Label("Profile", systemImage: "person.circle")
                        }
                }
            } else {
                LoginView(viewModel: loginViewModel)
                    .environmentObject(sessionManager)
            }
        }
        .onAppear {
            if !sessionManager.isLoggedIn {
                isPresentingLogin = true
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
