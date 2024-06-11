//
//  RegisterAccountViewModel.swift
//  FilmValley2
//
//  Created by Trịnh Kiết Tường on 24/04/2024.
//

import Foundation
import Firebase
import FirebaseAuth

class RegisterAccountViewModel {
    func sendEmailVerification(email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            completion(error)
        })
    }
    
    func createUser(email: String, password: String, username: String, birthday: String, gender: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(false, error)
            } else {
                guard let uid = authResult?.user.uid else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get user UID"])
                    completion(false, error)
                    return
                }
                let userInfo: [String: Any] = [
                    "username": username,
                    "birthday": birthday,
                    "gender": gender,
                    "avatar": "gs://film-valley.appspot.com/default_avatar.jpeg"
                ]
                let databaseRef = Database.database().reference()
                let accountRef = databaseRef.child("Account").child(uid)
                accountRef.setValue(userInfo) { error, _ in
                    if let error = error {
                        completion(false, error)
                    } else {
                        completion(true, nil)
                    }
                }
            }
        }
    }
    
    func registerUser(withEmail email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                if error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                    completion(false)
                } else {
                    print("Error creating user: \(error.localizedDescription)")
                    completion(false)
                }
            } else {
                if let user = authResult?.user {
                    user.delete { error in
                        if let error = error {
                            print("Error deleting user: \(error.localizedDescription)")
                            completion(false)
                        } else {
                            print("User deleted successfully.")
                            completion(true)
                        }
                    }
                }
            }
        }
    }
    
    
    func checkUsernameExists(username: String, completion: @escaping (Bool, Error?) -> Void) {
        let databaseRef = Database.database().reference().child("Account")
        databaseRef.queryOrdered(byChild: "username").queryEqual(toValue: username).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        } withCancel: { (error) in
            completion(false, error)
        }
    }
    
    func createUserInFavouriteList(userId: String, completion: @escaping (Error?) -> Void) {
        let databaseRef = Database.database().reference().child("Favourite").child(userId)
        databaseRef.setValue("") { error, _ in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
}
