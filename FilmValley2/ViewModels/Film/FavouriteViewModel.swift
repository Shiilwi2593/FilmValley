//
//  FavouriteViewModel.swift
//  FilmValley2
//
//  Created by Trịnh Kiết Tường on 13/05/2024.
//

import Foundation
import Firebase
import FirebaseAuth

class FavouriteViewModel{
    //MARK: -Favourite List
    typealias Films = [Film]
    
    var filmFavArray: Films = []
    
    var listIDFav: [String] = []
    
    func fetchFavDataFromFirebase(completion: @escaping () -> Void){
        let database = Database.database().reference()
        database.child("Film").observeSingleEvent(of: .value) { Snapshot in
            guard let filmsData = Snapshot.value as? [String: Any] else{
                return
            }
            for id in self.listIDFav{
                guard let filmData = filmsData[id] as? [String: Any],
                      let title = filmData["title"] as? String,
                      let year = filmData["year"] as? Int,
                      let director = filmData["director"] as? String,
                      let des = filmData["des"] as? String,
                      let genres = filmData["genres"] as? [String],
                      let cast = filmData["cast"] as? [String],
                      let imageUrl = filmData["imageUrl"] as? String,
                      let rating = filmData["rating"] as? Double,
                      let background = filmData["background"] as? String,
                      let trailer = filmData["trailer"] as? String,
                      let embed = filmData["embed"] as? String
                else {
                    continue
                }
                
                let newFilm = Film(id: id, title: title, year: year, director: director, des: des, genres: genres, cast: cast, imageUrl: imageUrl, rating: rating, background: background, trailer: trailer, embed: embed)
                self.filmFavArray.append(newFilm)
            }
            completion()
        }
    }
    
    func getListFavourite(completion: @escaping ([String]?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let databaseRef = Database.database().reference().child("Favourite").child(uid)
        databaseRef.observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                print("Dữ liệu không tồn tại")
                completion(nil)
                return
            }
            if let list = value["List"] as? [String] {
                let updatedList = Array(list.dropFirst())
                self.listIDFav = updatedList
                completion(updatedList)
            } else {
                print("Không tìm thấy chuỗi list")
                completion(nil)
            }
        }
    }
    
    func getLength() -> Int{
        return self.filmFavArray.count
    }
}
