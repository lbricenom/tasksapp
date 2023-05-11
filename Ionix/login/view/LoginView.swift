//
//  SwiftUIView.swift
//  Ionix
//
//  Created by luis on 10/05/23.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sessionManager: AuthSessionManager

    @StateObject var viewModel: LoginViewModel
    @State private var forgotPasswordUsername = ""

    var body: some View {
        VStack(spacing: 20) {
            Image("ionix")
            TextField("Username", text: $viewModel.username)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.white)
                .cornerRadius(10)
                .foregroundColor(.black)
                .accentColor(.black)
                .shadow(color: Color.gray.opacity(0.4), radius: 3, x: 1, y: 2)
            SecureField("Password", text: $viewModel.password)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.white)
                .foregroundColor(.black)
                .accentColor(.black)
                .cornerRadius(10)
                .shadow(color: Color.gray.opacity(0.4), radius: 3, x: 1, y: 2)
            Button("Login") {
                Task {
                    do {
                        try await viewModel.login()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                
            }
            .disabled(viewModel.isLoggingIn)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.4), radius: 3, x: 1, y: 2)
            .padding(.horizontal, 20)
            
            Button("Forgot Password") {
                Task {
                    do {
                        try await viewModel.forgotPassword()
                        viewModel.alertMessage = "Password reset instructions sent to your email."
                        viewModel.isShowingAlert = true
                    } catch {
                        print(error)
                        viewModel.alertMessage = error.localizedDescription
                        viewModel.isShowingAlert = true
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.4), radius: 3, x: 1, y: 2)
            .padding(.horizontal, 20)
        }
        .padding(.horizontal, 20)
        .onReceive(viewModel.$loginResult) { result in
            switch result {
            case .success(let profile):
                sessionManager.login(userProfile: profile)
                viewModel.username = ""
                viewModel.password = ""
                viewModel.loginResult = nil
                dismissView()
            case .failure(let error):
                viewModel.alertMessage = error.localizedDescription
                viewModel.isShowingAlert = true
            case .none:
                break
            }
        }
        .alert(isPresented: $viewModel.isShowingAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }

    }

    private func dismissView() {
        withAnimation {
            presentationMode.wrappedValue.dismiss()
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel(authService: AuthServiceImpl()))
    }
}
