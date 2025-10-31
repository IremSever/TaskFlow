//
//  TaskFlowApp.swift
//  TaskFlow
//
//  Created by İrem Sever on 29.10.2025.
//

import SwiftUI
import CoreData
import FirebaseCore
import Combine

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
@main
struct TaskFlowApp: App {
    @StateObject var authVM = AuthViewModel()
    @StateObject var appState = AppState()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            Group {
                if authVM.isAuthenticated {
                    RootTabView()
                } else {
                    AuthView()
                }
            }
            .environmentObject(authVM)
            .environmentObject(appState)
            .onAppear { appState.applyTheme() }
        }
    }
}
