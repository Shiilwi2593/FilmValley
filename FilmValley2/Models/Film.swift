//
//  Film.swift
//  FilmValley
//
//  Created by Trịnh Kiết Tường on 07/04/2024.
//

import Foundation

struct Film{
    let id: String
    let title:String
    let year: Int
    let director: String
    let des: String
    let genres:[String]
    let cast: [String]
    let imageUrl: String
    let rating: Double
    let background: String
    let trailer: String
    let embed: String
    
    init(id: String, title: String, year: Int, director: String, des: String, genres: [String], cast: [String], imageUrl: String, rating: Double, background: String, trailer: String, embed: String) {
        self.id = id
        self.title = title
        self.year = year
        self.director = director
        self.des = des
        self.genres = genres
        self.cast = cast
        self.imageUrl = imageUrl
        self.rating = rating
        self.background = background
        self.trailer = trailer
        self.embed = embed
    }
}





