//
//  DetailViewModel.swift
//  FilmValley2
//
//  Created by Trịnh Kiết Tường on 10/05/2024.
//

import Foundation
import Firebase
import FirebaseAuth

class DetailViewModel{
    //MARK: Favourite
    func check(idFilm: String, completion: @escaping (Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            completion(false)
            return
        }
        
        let ref = Database.database().reference().child("Favourite").child(uid).child(idFilm)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func addFilmToFavouriteList(idFilm: String) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let databaseRef = Database.database().reference().child("Favourite").child(uid).child(idFilm)
        databaseRef.setValue(true) { error, _ in
            if let error = error {
                print("Error adding film to favourite list: \(error.localizedDescription)")
            } else {
                print("Film added to favourite list successfully")
            }
        }
        let databaseRefList = Database.database().reference().child("Favourite").child(uid).child("List")
        databaseRefList.observeSingleEvent(of: .value) { snapshot in
            if var filmsArray = snapshot.value as? [String] {
                filmsArray.append(idFilm)
                databaseRefList.setValue(filmsArray) { error, _ in
                    if let error = error {
                        print("Error updating favourite list: \(error.localizedDescription)")
                    } else {
                        print("Favourite list updated successfully")
                    }
                }
            } else {
                let filmsArray = ["default", idFilm]
                databaseRefList.setValue(filmsArray) { error, _ in
                    if let error = error {
                        print("Error updating favourite list: \(error.localizedDescription)")
                    } else {
                        print("Favourite list updated successfully")
                    }
                }
            }
        }
    }
    
    func removeFilmFromFavouriteList(idFilm: String){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let databaseRef = Database.database().reference().child("Favourite").child(uid)
        databaseRef.child(idFilm).removeValue { error, _ in
            if let error = error {
                print("Error removing film from favourite list: \(error.localizedDescription)")
            } else {
                print("Film removed from favourite list successfully")
            }
            
            let databaseRefList = databaseRef.child("List")
            databaseRefList.observeSingleEvent(of: .value) { snapshot in
                if var filmsArray = snapshot.value as? [String], let index = filmsArray.firstIndex(of: idFilm) {
                    filmsArray.remove(at: index)
                    
                    // Check if array is empty or has one element left
                    if filmsArray.isEmpty {
                        filmsArray.append("") // Set the last element to ""
                    }
                    
                    // Update the array in the database
                    databaseRefList.setValue(filmsArray) { error, _ in
                        if let error = error {
                            print("Error updating favourite list: \(error.localizedDescription)")
                        } else {
                            print("Favourite list updated successfully")
                        }
                    }
                }
            }
        }
    }
    
    
    //MARK: -RateChart
    
    var dataArr: [String] = []
    
    var chartData: [(rating: Int, count: Int)] = [
        (1, 0),
        (2, 0),
        (3, 0),
        (4, 0),
        (5, 0),
        (6, 0),
        (7, 0),
        (8, 0),
        (9, 0),
        (10, 0)
    ]
    
    //get review array from Film
    func getData(filmID: String,completion: @escaping ([String]) -> Void) {
        let ref = Database.database().reference().child("Film").child(filmID).child("reviews")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            if let data = snapshot.value as? [String] {
                completion(data)
            } else {
                completion([])
            }
        }
    }
    
    //get AvgPoint, ChartData
    func getPoint(data: [String], completion: @escaping ([Double]) -> Void) {
        var points: [Double] = []
        let ref = Database.database().reference().child("Reviews")
        let group = DispatchGroup()
        
        for index in data {
            group.enter()
            let tempRef = ref.child(index).child("ratePoint")
            tempRef.observeSingleEvent(of: .value) { snapshot in
                if let data = snapshot.value as? Double {
                    points.append(data)
                    if let rating = Int(exactly: data), rating >= 1, rating <= 10 {
                        if let i = self.chartData.firstIndex(where: { $0.rating == rating }) {
                            self.chartData[i].count += 1
                        }
                    }
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(points)
        }
    }
    
    //MARK: -AVPlayer
    func storeWatchingFilm(idFilm: String, minutes: Int){
        
    }
    
}
