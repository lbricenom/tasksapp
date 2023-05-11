//
//  ProfileView.swift
//  Ionix
//
//  Created by luis on 10/05/23.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var sessionManager: AuthSessionManager
    
    var body: some View {
        VStack {
            Text("Hello, \(sessionManager.userProfile?.username ?? "")!")
                .font(.title)
                .padding()
            
            Spacer()
            
            Button("Logout") {
                sessionManager.logout()
            }
            .padding()
        }
        .navigationBarTitle("Profile")
    }
}
