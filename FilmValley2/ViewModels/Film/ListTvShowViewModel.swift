//
//  ListTvShowViewModel.swift
//  FilmValley2
//
//  Created by Trịnh Kiết Tường on 24/06/2024.
//

import Foundation
import Firebase
import FirebaseDatabase

class ListTvShowViewModel {
    typealias TVShowsList = [TVShows]

    var tvShowArray: TVShowsList = []

    init() {}

    func fetchDataFromFirebase(completion: @escaping () -> Void) {
        let database = Database.database().reference()
        database.child("TVShows").observeSingleEvent(of: .value) { snapshot in
            guard let tvShowsData = snapshot.value as? [String: Any] else {
                print("No data found")
                completion()
                return
            }
            for tvShowKey in tvShowsData.keys.sorted() {
                guard let tvShow = tvShowsData[tvShowKey] as? [String: Any] else {
                    print("Failed to parse TV show with key \(tvShowKey)")
                    continue
                }
                
                print("Parsing TV show with key \(tvShowKey): \(tvShow)")
                
                guard let title = tvShow["title"] as? String else {
                    print("Missing or invalid 'title' for key \(tvShowKey)")
                    continue
                }
                guard let year = tvShow["year"] as? Int else {
                    print("Missing or invalid 'year' for key \(tvShowKey)")
                    continue
                }
                guard let creator = tvShow["creator"] as? String else {
                    print("Missing or invalid 'creator' for key \(tvShowKey)")
                    continue
                }
                guard let des = tvShow["des"] as? String else {
                    print("Missing or invalid 'des' for key \(tvShowKey)")
                    continue
                }
                guard let embed = tvShow["embed"] as? [String] else{
                    print("Missing or invalid 'embed")
                    continue
                }
                
                guard let genres = tvShow["genres"] as? [String] else {
                    print("Missing or invalid 'genres' for key \(tvShowKey)")
                    continue
                }
                guard let cast = tvShow["cast"] as? [String] else {
                    print("Missing or invalid 'cast' for key \(tvShowKey)")
                    continue
                }
                guard let imageUrl = tvShow["imageUrl"] as? String else {
                    print("Missing or invalid 'imageUrl' for key \(tvShowKey)")
                    continue
                }
                guard let rating = tvShow["rating"] as? Double else {
                    print("Missing or invalid 'rating' for key \(tvShowKey)")
                    continue
                }
                guard let background = tvShow["background"] as? String else {
                    print("Missing or invalid 'background' for key \(tvShowKey)")
                    continue
                }
                guard let trailer = tvShow["trailer"] as? String else {
                    print("Missing or invalid 'trailer' for key \(tvShowKey)")
                    continue
                }
                guard let reviews = tvShow["reviews"] as? [String] else {
                    print("Missing or invalid 'reviews' for key \(tvShowKey)")
                    continue
                }
                
                let newTVShow = TVShows(
                    id: tvShowKey,
                    background: background,
                    cast: cast,
                    creator: creator,
                    des: des,
                    embed: embed,
                    genres: genres,
                    imageUrl: imageUrl,
                    rating: rating,
                    reviews: reviews,
                    title: title,
                    trailer: trailer,
                    year: year
                )
                self.tvShowArray.append(newTVShow)
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    public func getLength() -> Int {
        return tvShowArray.count
    }
}
