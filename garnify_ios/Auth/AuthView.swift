//
//  Auth.swift
//  garnify
//
//  Created by Vladyslav Oliinyk on 23.02.2023.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseAnalyticsSwift
import GoogleSignIn

struct AuthView: View {
    @State private var isLogined = false
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    
    private func signInWithGoogle() {
        Task {
          if await viewModel.signInWithGoogle() == true {
            dismiss()
          }
        }
      }
    
    var body: some View {
        NavigationView {
            ZStack{
                Color.yellow
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                VStack{
                    Spacer()
                    Image("g_icon")
                    Text("For a personalised experience, sign into your account")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .bold()
                        .padding([.bottom, .top], 20)
                    
                    Button(action: {
                        isLogined = true
                    }, label: {
                        Image("apple_sign_up")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 340, height: 100)
                    })
                    
                    Button(action: {
                        signInWithGoogle()
                    }, label: {
                        Image("google_sign_up")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 340, height: 100)
                    })
                    Spacer()
                }
            }
        }
        .navigate(to: MainMenuView(), when: $isLogined)
        .analyticsScreen(name: "AuthView")
    }
}

struct Auth_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
            .environmentObject(AuthenticationViewModel())
    }
}

extension View {
    /// Navigate to a new view.
    /// - Parameters:
    ///   - view: View to navigate to.
    ///   - binding: Only navigates when this condition is `true`.
    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>) -> some View {
        NavigationView {
            ZStack {
                self
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                
                NavigationLink(
                    destination: view
                        .navigationBarTitle("")
                        .navigationBarHidden(true),
                    isActive: binding
                ) {
                    EmptyView()
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

