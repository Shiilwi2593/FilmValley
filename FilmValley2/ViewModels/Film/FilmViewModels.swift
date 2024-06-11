//
//  FilmViewModels.swift
//  FilmValley
//
//  Created by Trịnh Kiết Tường on 08/04/2024.
//

import Foundation
import Firebase
import FirebaseDatabase

class FilmViewModels {
    typealias Films = [Film]

    var filmsArray: [Film] = []

    init() {
    }

    func fetchDataFromFirebase(completion: @escaping () -> Void) {
        let database = Database.database().reference()
        database.child("Film").observeSingleEvent(of: .value) { snapshot in
            guard let filmsData = snapshot.value as? [String: Any] else {
                print("No data found")
                return
            }
            for filmKey in filmsData.keys.sorted() {
                guard let film = filmsData[filmKey] as? [String: Any],
                      let title = film["title"] as? String,
                      let year = film["year"] as? Int,
                      let director = film["director"] as? String,
                      let des = film["des"] as? String,
                      let genres = film["genres"] as? [String],
                      let cast = film["cast"] as? [String],
                      let imageUrl = film["imageUrl"] as? String,
                      let rating = film["rating"] as? Double,
                      let background = film["background"] as? String,
                      let trailer = film["trailer"] as? String,
                      let embed = film["embed"] as? String
                else {
                    print("Failed to parse film with key \(filmKey)")
                    continue
                }
                let newFilm = Film(id: filmKey, title: title, year: year, director: director, des: des, genres: genres, cast: cast, imageUrl: imageUrl, rating: rating, background: background, trailer: trailer, embed: embed)
                self.filmsArray.append(newFilm)
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    public func getLength() -> Int {
        return filmsArray.count
    }
}





