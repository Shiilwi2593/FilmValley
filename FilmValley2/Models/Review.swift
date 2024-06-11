//
//  Review.swift
//  FilmValley2
//
//  Created by Trịnh Kiết Tường on 22/05/2024.
//

import Foundation
struct Review{
    let idFilm: String
    let idUser: String
    let ratePoint: Int
    let comment: String
    let timeStamp: String
    
    init(idFilm: String, idUser: String, ratePoint: Int, comment: String, timeStamp: String) {
        self.idFilm = idFilm
        self.idUser = idUser
        self.ratePoint = ratePoint
        self.comment = comment
        self.timeStamp = timeStamp
    }
    
    func toDictionary() -> [String: Any]{
        return[
            "idFilm": idFilm,
            "idUser": idUser,
            "ratePoint": ratePoint,
            "comment": comment,
            "timeStamp": timeStamp
            
        ]
    }
}
