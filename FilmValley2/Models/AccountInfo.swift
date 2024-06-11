//
//  AccountInfo.swift
//  FilmValley2
//
//  Created by Trịnh Kiết Tường on 04/05/2024.
//

import Foundation
struct AccountInfo {
    let username: String
    let email: String
    let gender: String
    let birthday: String
    let avatarURL: String
    let dateJoined: String
    
    init(username: String, email: String, gender: String, birthday: String, avatarURL: String, đateJoined: String) {
        self.username = username
        self.email = email
        self.gender = gender
        self.birthday = birthday
        self.avatarURL = avatarURL
        self.dateJoined = đateJoined
    }
}


