//
//  AppState.swift
//  TaskFlow
//
//  Created by İrem Sever on 29.10.2025.
//
import SwiftUI
import Firebase
import Combine
import FirebaseAuth

@MainActor
final class AppState: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var userRole: UserRole = .tech
    @Published var isConnected: Bool = true
    @Published var lastSyncAt: Date? = nil
    @AppStorage("appTheme") var appTheme: Int = 2

    private let auth = AuthService()
    private let db = Firestore.firestore()

    private func listenAuthChanges() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self else { return }
            Task { await self.refreshUser(user) }
        }
    }

    func refreshUser(_ user: FirebaseAuth.User?) async {
        guard let user else {
            isAuthenticated = false
            return
        }
        do {
            let doc = try await db.collection("users").document(user.uid).getDocument()
            if let role = doc.data()?["role"] as? String {
                userRole = role == "admin" ? .admin : .tech
            }
            isAuthenticated = true
        } catch {
            print("⚠️ Kullanıcı bilgisi alınamadı: \(error.localizedDescription)")
            isAuthenticated = true
        }
    }

    func signOut() {
        try? auth.signOut()
        isAuthenticated = false
    }

    func setTheme(_ mode: Int) {
        appTheme = mode
        switch mode {
        case 0: UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
        case 1: UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
        default: UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .unspecified
        }
    }

    func applyTheme() {
        #if os(iOS)
        let style: UIUserInterfaceStyle = switch appTheme {
        case 0: .light
        case 1: .dark
        default: .unspecified
        }
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .forEach { $0.overrideUserInterfaceStyle = style }
        #endif
    }
}
