//
//  ProfileView.swift
//  garnify_ios
//
//  Created by Vladyslav Oliinyk on 16.03.2023.
//

import Foundation
import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var isShowingAuthView = false
    
    private func signOut() {
            Task {
                viewModel.signOut()
                viewModel.authenticationState = .unauthenticated // Update the authentication state
                isShowingAuthView = true // Show the login page
            }
        }
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.yellow
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                VStack {
                    Image(systemName: "globe") // Replace "userAvatar" with the name of your avatar image
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding(.top, 20)
                    
                    Text("Username") // Replace "Username" with the name of your user
                        .font(.title)
                        .padding(.top, 10)
                    
                    Spacer()
                    
                    Button(action: {
                        signOut()
                    }) {
                        Text("Logout")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                    }
                    
                    Button(action: {
                        // Code to handle personal information action
                    }) {
                        Text("Personal Information")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $isShowingAuthView) {
            AuthView()
                .environmentObject(viewModel)
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
            .environmentObject(AuthenticationViewModel())
    }
}
