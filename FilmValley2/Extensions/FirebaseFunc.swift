//
//  GetFirebaseData.swift
//  FilmValley2
//
//  Created by Trịnh Kiết Tường on 21/04/2024.
//

import Foundation
import Firebase
import FirebaseDatabase


func checkUsernameExistence(forUID uid: String, completion: @escaping (Bool) -> Void) {
    let ref = Database.database().reference().child("Account").child(uid).child("username")
    
    ref.observeSingleEvent(of: .value) { (snapshot) in
        if snapshot.exists() {
            completion(true)
        } else {
            completion(false)
        }
    }
}
