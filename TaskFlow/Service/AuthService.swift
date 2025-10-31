//
//  AuthService.swift
//  TaskFlow
//
//  Created by İrem Sever on 29.10.2025.
//

import Foundation
import FirebaseAuth

final class AuthService {

    func signIn(email: String, password: String) async throws -> FirebaseAuth.User {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.user
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    var currentUser: FirebaseAuth.User? {
        Auth.auth().currentUser
    }
}
