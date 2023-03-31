//
//  garnify_iosApp.swift
//  garnify_ios
//
//  Created by Vladyslav Oliinyk on 15.03.2023.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}


@main
struct garnify_iosApp: App {
    @StateObject var authViewModel = AuthenticationViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            AuthView()
                .environmentObject(authViewModel)
        }
    }
}
