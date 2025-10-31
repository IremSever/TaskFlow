//
//  AuthViewModel.swift
//  TaskFlow
//
//  Created by İrem Sever on 29.10.2025.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Combine
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isAuthenticated = false
    @Published var role: UserRole = .tech
    @Published var isLoading = false
    @Published var errorText: String? = nil

    private var handle: AuthStateDidChangeListenerHandle?
    private let db = Firestore.firestore()

    init() {
        attachAuthListener()
        if let user = Auth.auth().currentUser {
            Task { await loadRole(for: user.uid) }
            isAuthenticated = true
        }
    }

    deinit {
        if let h = handle { Auth.auth().removeStateDidChangeListener(h) }
    }

    private func attachAuthListener() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self else { return }
            Task { @MainActor in
                if let user {
                    self.isAuthenticated = true
                    await self.loadRole(for: user.uid)
                } else {
                    self.isAuthenticated = false
                    self.role = .tech
                }
            }
        }
    }

    func signIn(rememberEmail: Bool = false) async {
        guard !email.isEmpty, !password.isEmpty else {
            errorText = "Geçersiz e-posta veya şifre."
            return
        }
        isLoading = true; defer { isLoading = false }
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            isAuthenticated = true
            errorText = nil
            await loadRole(for: result.user.uid)
            if rememberEmail { UserDefaults.standard.set(email, forKey: "taskflow.cached.email") }
        } catch {
            errorText = "Geçersiz e-posta veya şifre."
            isAuthenticated = false
        }
    }

    func signOut() {
        try? Auth.auth().signOut()
        isAuthenticated = false
        role = .tech
    }

    func restoreCachedEmail() {
        if let e = UserDefaults.standard.string(forKey: "taskflow.cached.email") {
            email = e
        }
    }

    private func loadRole(for uid: String) async {
        do {
            let snap = try await db.collection("users").document(uid).getDocument()
            if let r = snap.data()?["role"] as? String, r == "admin" {
                role = .admin
            } else {
                role = .tech
            }
        } catch {
            role = .tech
        }
    }
}

enum UserRole: String { case admin, tech }
