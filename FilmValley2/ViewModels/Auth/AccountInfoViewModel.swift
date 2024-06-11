//
//  AccountInfoViewModel.swift
//  FilmValley2
//
//  Created by Trịnh Kiết Tường on 03/05/2024.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage


class AccountInfoViewModel {
    //MARK: UserInfo
    func fetchUserInfo(completion: @escaping (AccountInfo?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(nil)
            return
        }
        
        let id = currentUser.uid
        let ref = Database.database().reference().child("Account").child(id)
        
        ref.observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                print("Snapshot value is not valid")
                completion(nil)
                return
            }
            let username = value["username"] as? String ?? ""
            let email = currentUser.email ?? ""
            let gender = value["gender"] as? String ?? ""
            let birthday = value["birthday"] as? String ?? ""
            let avatar = value["avatar"] as? String ?? ""
            let dateJoined = currentUser.metadata.creationDate ?? Date()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy"
            
            let dateString = dateFormatter.string(from: dateJoined)
            
            let accountInfo = AccountInfo(username: username, email: email, gender: gender, birthday: birthday, avatarURL: avatar, đateJoined: dateString)
            
            completion(accountInfo)
        }, withCancel: { error in
            print("Error fetching account info:", error.localizedDescription)
            completion(nil)
        })
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
    
    func uploadImageToFirebase(_ image: UIImage, completion: @escaping (String?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageName = UUID().uuidString
        let imageRef = storageRef.child("avatar/\(imageName).jpg")
        
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            imageRef.putData(imageData, metadata: nil) { metadata, error in
                guard let _ = metadata else {
                    print("Error uploading image:", error ?? "Unknown error")
                    completion(nil)
                    return
                }
                
                imageRef.getMetadata { metadata, error in
                    guard let _ = metadata else {
                        print("Error getting metadata:", error ?? "Unknown error")
                        completion(nil)
                        return
                    }
                    
                    completion(imageRef.fullPath)
                }
            }
        } else {
            print("Error converting image to data")
            completion(nil)
        }
    }
    
    func updateAvatar(url: String){
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        let id = currentUser.uid
        let ref = Database.database().reference().child("Account").child(id)
        
        
        ref.child("avatar").observeSingleEvent(of: .value) { snapshot in
            guard let currentURL = snapshot.value as? String else {
                print("No avatar URL found")
                return
            }
            
            let storage = Storage.storage()
            let storageRef = storage.reference(forURL: currentURL)
            
            if currentURL == "gs://film-valley.appspot.com/default_avatar.jpeg" {
                ref.updateChildValues(["avatar": url]) { error, _ in
                    if error != nil {
                        print("Error updating avatar URL in database")
                        return
                    }
                    print("Avatar URL updated")
                }
            } else {
                storageRef.delete { error in
                    if let error = error {
                        print("Error deleting image from storage: \(error.localizedDescription)")
                        return
                    }
                    ref.updateChildValues(["avatar": url]) { error, _ in
                        if error != nil {
                            print("Error updating avatar URL in database")
                            return
                        }
                        print("Avatar URL updated")
                    }
                }
            }
        }
    }
    
}
