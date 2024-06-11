//
//  LoginViewModel.swift
//  FilmValley2
//
//  Created by Trịnh Kiết Tường on 25/04/2024.
//

import Foundation
import Firebase
import FirebaseAuth

class LoginViewModel{
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                completion(.success(user))
            }
        }
    }
}
