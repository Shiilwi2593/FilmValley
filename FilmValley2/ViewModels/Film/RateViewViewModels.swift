//
//  RateViewViewModels.swift
//  FilmValley2
//
//  Created by Trịnh Kiết Tường on 21/05/2024.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage

class RateViewViewModels{
    
    
    //MARK: -Film
    func StoreReview(idFilm: String, ratePoint: Int, Comment: String){
        guard let userID = Auth.auth().currentUser?.uid else {
            print("RateFunc-Can't get user ID")
            return
        }
        hasUserReviewedFilm(userID: userID, filmID: idFilm) { [weak self] hasReviewed, _, _ in
            if hasReviewed {
                self?.updateReview(idFilm: idFilm, ratePoint: ratePoint, comment: Comment)
            } else {
                self?.addNewReview(idFilm: idFilm, ratePoint: ratePoint, comment: Comment, userID: userID)
            }
        }
    }
    
    private func updateReview(idFilm: String, ratePoint: Int, comment: String) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("RateFunc-Can't get user ID")
            return
        }
        
        let reviewRef = Database.database().reference().child("Reviews")
        
        reviewRef.queryOrdered(byChild: "idFilm").queryEqual(toValue: idFilm).observeSingleEvent(of: .value) { snapshot in
            guard let reviewsDict = snapshot.value as? [String: [String: Any]] else {
                print("No reviews found for this film")
                return
            }
            
            for (reviewID, reviewData) in reviewsDict {
                if let reviewUserID = reviewData["idUser"] as? String, reviewUserID == userID {
                    let currentTime = Date()
                    let formattedTime = self.formattedDate(currentTime)
                    let updatedReviewData: [String: Any] = ["ratePoint": ratePoint,
                                                            "comment": comment,
                                                            "timeStamp": formattedTime]
                    let reviewRef = reviewRef.child(reviewID)
                    reviewRef.updateChildValues(updatedReviewData) { error, _ in
                        if let error = error {
                            print("Error updating review: \(error.localizedDescription)")
                        } else {
                            print("Review updated successfully!")
                        }
                    }
                    return
                }
            }
        }
    }
    
    private func addNewReview(idFilm: String, ratePoint: Int, comment: String, userID: String) {
        let currentTime = Date()
        let formattedTime = formattedDate(currentTime)
        let review = Review(idFilm: idFilm, idUser: userID, ratePoint: ratePoint, comment: comment, timeStamp: formattedTime)
        let idReview = UUID().uuidString
        let reviewRef = Database.database().reference().child("Reviews").child(idReview)
        let filmRef = Database.database().reference().child("Film").child(idFilm).child("reviews")
        reviewRef.setValue(review.toDictionary()) { error, _ in
            if let error = error {
                print("Error adding review: \(error.localizedDescription)")
            } else {
                print("Review added successfully!")
                filmRef.observeSingleEvent(of: .value) { snapshot in
                    if var reviewsArray = snapshot.value as? [String] {
                        reviewsArray.append(idReview)
                        filmRef.setValue(reviewsArray) { error, _ in
                            if let error = error {
                                print("Error adding idReview to the array: \(error.localizedDescription)")
                            } else {
                                print("idReview added to the array successfully!")
                            }
                        }
                    } else {
                        filmRef.setValue([idReview]) { error, _ in
                            if let error = error {
                                print("Error creating the reviews array: \(error.localizedDescription)")
                            } else {
                                print("Reviews array created and idReview added successfully!")
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm dd-MM-yyyy"
        return dateFormatter.string(from: date)
    }
    
    func hasUserReviewedFilm(userID: String, filmID: String, completion: @escaping (Bool, Int?, String?) -> Void){
        let databaseRef = Database.database().reference().child("Reviews")
        
        databaseRef.observeSingleEvent(of: .value) { snapshot, error in
            if let _ = error {
                print("Lỗi khi lấy dữ liệu")
                completion(false, nil, nil)
                return
            }
            guard let reviewsDict = snapshot.value as? [String: [String: Any]] else {
                completion(false, nil, nil)
                return
            }
            for (_, reviewData) in reviewsDict {
//                print("ID Đánh giá: \(reviewID), Dữ liệu: \(reviewData)")
                if let reviewUserID = reviewData["idUser"] as? String,
                   let reviewFilmID = reviewData["idFilm"] as? String {
//                    print("ID Người dùng đánh giá: \(reviewUserID), ID Phim đánh giá: \(reviewFilmID)")
                    if reviewUserID == userID && reviewFilmID == filmID {
                        print("Người dùng đã đánh giá phim này.")
                        let reviewRating = reviewData["ratePoint"] as? Int
                        let reviewComment = reviewData["comment"] as? String
                        completion(true, reviewRating, reviewComment)
                        return
                    }
                } else {
//                    print("Không tìm thấy key idUser hoặc idFilm trong dữ liệu đánh giá")
                }
            }
            print("Người dùng chưa đánh giá phim này.")
            completion(false, nil, nil)
        }
    }
    
    
    func getListComment(idFilm: String, completion: @escaping ([Review]) -> Void){
        let reviewRef = Database.database().reference().child("Reviews")
        let query = reviewRef.queryOrdered(byChild: "idFilm").queryEqual(toValue: idFilm)
        
        query.observeSingleEvent(of: .value) { snapshot in
            var reviews: [Review] = []
            for child in snapshot.children{
                if let childSnapshot = child as? DataSnapshot,
                   let reviewDict = childSnapshot.value as? [String: Any],
                   let idFilm = reviewDict["idFilm"] as? String,
                   let idUser = reviewDict["idUser"] as? String,
                   let ratePoint = reviewDict["ratePoint"] as? Int,
                   let comment = reviewDict["comment"] as? String,
                   let timeStamp = reviewDict["timeStamp"] as? String {
                    
                    let review = Review(idFilm: idFilm, idUser: idUser, ratePoint: ratePoint, comment: comment, timeStamp: timeStamp)
                    reviews.append(review)
                }
            }
            completion(reviews)
        }
    }
    
    func getUsernameFromID(idUser: String, completion: @escaping (String) -> Void){
        let ref = Database.database().reference().child("Account").child(idUser).child("username")
        ref.observeSingleEvent(of: .value) { snapshot in
            if let username = snapshot.value as? String{
                completion(username)
            }
            else{
                completion("unknown")
            }
        }
    }
    
    func getImageFromId(idUser: String, completion: @escaping (String) -> Void){
        let ref = Database.database().reference().child("Account").child(idUser).child("avatar")
        ref.observeSingleEvent(of: .value) { snapshot in
            if let imageUrl = snapshot.value as? String{
                completion(imageUrl)
            }
            else{
                completion("error")
            }
        }
    }
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void){
        let storageRef = Storage.storage().reference(forURL: urlString)
        
        storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading image:", error.localizedDescription)
                completion(nil)
            } else {
                if let imageData = data, let image = UIImage(data: imageData) {
                    completion(image)
                } else {
                    print("Invalid image data or no image received")
                    completion(nil)
                }
            }
        }
    }
    
    func getInfoUserByID(idUser: String, completion: @escaping ([String: Any]?) -> Void){
        let ref = Database.database().reference().child("Account").child(idUser)
        
        ref.observeSingleEvent(of: .value) { data in
            guard let userInfo = data.value as? [String: Any] else{
                print("can't get user info")
                completion(nil)
                return
            }
            print(userInfo)
            completion(userInfo)
        }
    }
    
    
    
    
    
    //MARK: -TVShow
    func StoreTVShowReview(idTVShow: String, ratePoint: Int, Comment: String){
        guard let userID = Auth.auth().currentUser?.uid else {
            print("RateFunc-Can't get user ID")
            return
        }
        hasUserReviewedTVShow(userID: userID, tvShowID: idTVShow) { [weak self] hasReviewed, _, _ in
            if hasReviewed {
                self?.updateReview(idFilm: idTVShow, ratePoint: ratePoint, comment: Comment)
            } else {
                self?.addTVShowNewReview(tvShowID: idTVShow, ratePoint: ratePoint, comment: Comment, userID: userID)
            }
        }
    }
    
    func hasUserReviewedTVShow(userID: String, tvShowID: String, completion: @escaping (Bool, Int?, String?) -> Void){
        let databaseRef = Database.database().reference().child("Reviews")
        
        databaseRef.observeSingleEvent(of: .value) { snapshot, error in
            if let _ = error {
                print("Lỗi khi lấy dữ liệu")
                completion(false, nil, nil)
                return
            }
            guard let reviewsDict = snapshot.value as? [String: [String: Any]] else {
                completion(false, nil, nil)
                return
            }
            for (_, reviewData) in reviewsDict {
//                print("ID Đánh giá: \(reviewID), Dữ liệu: \(reviewData)")
                if let reviewUserID = reviewData["idUser"] as? String,
                   let reviewFilmID = reviewData["idFilm"] as? String {
//                    print("ID Người dùng đánh giá: \(reviewUserID), ID Phim đánh giá: \(reviewFilmID)")
                    if reviewUserID == userID && reviewFilmID == tvShowID {
                        print("Người dùng đã đánh giá phim này.")
                        let reviewRating = reviewData["ratePoint"] as? Int
                        let reviewComment = reviewData["comment"] as? String
                        completion(true, reviewRating, reviewComment)
                        return
                    }
                } else {
//                    print("Không tìm thấy key idUser hoặc idFilm trong dữ liệu đánh giá")
                }
            }
            print("Người dùng chưa đánh giá phim này.")
            completion(false, nil, nil)
        }
    }
    
    
    private func addTVShowNewReview(tvShowID: String, ratePoint: Int, comment: String, userID: String) {
        let currentTime = Date()
        let formattedTime = formattedDate(currentTime)
        let review = Review(idFilm: tvShowID, idUser: userID, ratePoint: ratePoint, comment: comment, timeStamp: formattedTime)
        let idReview = UUID().uuidString
        let reviewRef = Database.database().reference().child("Reviews").child(idReview)
        let filmRef = Database.database().reference().child("TVShows").child(tvShowID).child("reviews")
        reviewRef.setValue(review.toDictionary()) { error, _ in
            if let error = error {
                print("Error adding review: \(error.localizedDescription)")
            } else {
                print("Review added successfully!")
                filmRef.observeSingleEvent(of: .value) { snapshot in
                    if var reviewsArray = snapshot.value as? [String] {
                        reviewsArray.append(idReview)
                        filmRef.setValue(reviewsArray) { error, _ in
                            if let error = error {
                                print("Error adding idReview to the array: \(error.localizedDescription)")
                            } else {
                                print("idReview added to the array successfully!")
                            }
                        }
                    } else {
                        filmRef.setValue([idReview]) { error, _ in
                            if let error = error {
                                print("Error creating the reviews array: \(error.localizedDescription)")
                            } else {
                                print("Reviews array created and idReview added successfully!")
                            }
                        }
                    }
                }
            }
        }
    }
    
   
    
    
    //MARK: -ListComment
    func getListComment(tvShowID: String, completion: @escaping ([Review]) -> Void){
        let reviewRef = Database.database().reference().child("Reviews")
        let query = reviewRef.queryOrdered(byChild: "idFilm").queryEqual(toValue: tvShowID)
        
        query.observeSingleEvent(of: .value) { snapshot in
            var reviews: [Review] = []
            for child in snapshot.children{
                if let childSnapshot = child as? DataSnapshot,
                   let reviewDict = childSnapshot.value as? [String: Any],
                   let idFilm = reviewDict["idFilm"] as? String,
                   let idUser = reviewDict["idUser"] as? String,
                   let ratePoint = reviewDict["ratePoint"] as? Int,
                   let comment = reviewDict["comment"] as? String,
                   let timeStamp = reviewDict["timeStamp"] as? String {
                    
                    let review = Review(idFilm: idFilm, idUser: idUser, ratePoint: ratePoint, comment: comment, timeStamp: timeStamp)
                    reviews.append(review)
                }
            }
            completion(reviews)
        }
    }
    
    
    
}

