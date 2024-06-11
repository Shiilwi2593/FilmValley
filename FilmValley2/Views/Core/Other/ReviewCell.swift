//
//  ReviewView.swift
//  FilmValley2
//
//  Created by Trịnh Kiết Tường on 25/05/2024.
//

import UIKit

class ReviewCell: UITableViewCell {
    
    let username: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    let avatar: UIImageView = {
        let avatar = UIImageView()
        avatar.clipsToBounds = true
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.layer.borderWidth = 1
        avatar.layer.borderColor = UIColor.black.cgColor
        avatar.contentMode = .scaleAspectFill
        return avatar
    }()
    
    let commentText: UILabel = {
        let comment = UILabel()
        comment.translatesAutoresizingMaskIntoConstraints = false
        comment.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        comment.numberOfLines = 2
        comment.textAlignment = .left
        return comment
    }()
    
    let rating: UIImageView = {
       let rating = UIImageView()
        rating.translatesAutoresizingMaskIntoConstraints = false
        return rating
    }()
    
    let timeStamp: UILabel = {
        let timeStamp = UILabel()
        timeStamp.translatesAutoresizingMaskIntoConstraints = false
        timeStamp.font = UIFont.systemFont(ofSize: 11, weight: .light)
        timeStamp.textColor = .systemGray2
        return timeStamp
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(username)
        addSubview(avatar)
        addSubview(commentText)
        addSubview(rating)
        addSubview(timeStamp)
        
        // Set constraints for the avatar and label
        NSLayoutConstraint.activate([
            avatar.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20),
            avatar.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            avatar.heightAnchor.constraint(equalToConstant: 48),
            avatar.widthAnchor.constraint(equalToConstant: 48),
            
            username.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 10),
            username.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            username.heightAnchor.constraint(equalToConstant: 20),
            username.trailingAnchor.constraint(equalTo: rating.leadingAnchor, constant: -10),
            
            commentText.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 10),
            commentText.topAnchor.constraint(equalTo: username.bottomAnchor),
            commentText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            
            rating.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            rating.centerYAnchor.constraint(equalTo: username.centerYAnchor),
            rating.heightAnchor.constraint(equalToConstant: 30),
            rating.widthAnchor.constraint(equalToConstant: 30),
            
            timeStamp.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 10),
            timeStamp.topAnchor.constraint(equalTo: commentText.bottomAnchor, constant: 7),
            timeStamp.heightAnchor.constraint(equalToConstant: 10)
        ])
        avatar.layer.cornerRadius = 25
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

