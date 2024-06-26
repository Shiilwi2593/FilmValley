//
//  TVShows.swift
//  FilmValley2
//
//  Created by Trịnh Kiết Tường on 18/06/2024.
//

import Foundation

struct TVShows{
    let id: String
    let background: String
    let cast: [String]
    let creator: String
    let des: String
    let embed: [String]
    let genres: [String]
    let imageUrl: String
    let rating: Double
    let reviews: [String]
    let title: String
    let trailer: String
    let year: Int
    
    init(id: String, background: String, cast: [String], creator: String, des: String,embed: [String], genres: [String], imageUrl: String, rating: Double, reviews: [String], title: String, trailer: String, year: Int) {
        self.id = id
        self.background = background
        self.cast = cast
        self.creator = creator
        self.des = des
        self.embed = embed
        self.genres = genres
        self.imageUrl = imageUrl
        self.rating = rating
        self.reviews = reviews
        self.title = title
        self.trailer = trailer
        self.year = year
    }
    
}


