//
//  ReviewCellViewController.swift
//  FilmValley2
//
//  Created by Trịnh Kiết Tường on 25/05/2024.
//

import UIKit

class ReviewCellViewController: UIViewController {

    let avatarImageView = UIImageView()
        let usernameLabel = UILabel()
        let reviewLabel = UILabel()
        let ratingLabel = UILabel()

        override init(frame: CGRect) {
            super.init(frame: frame)
            setupViews()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupViews()
        }

        private func setupViews() {
            // Configure avatar image view
            avatarImageView.translatesAutoresizingMaskIntoConstraints = false
            avatarImageView.layer.cornerRadius = 20
            avatarImageView.clipsToBounds = true
            addSubview(avatarImageView)
            
            // Configure username label
            usernameLabel.translatesAutoresizingMaskIntoConstraints = false
            usernameLabel.font = UIFont.boldSystemFont(ofSize: 16)
            addSubview(usernameLabel)
            
            // Configure review label
            reviewLabel.translatesAutoresizingMaskIntoConstraints = false
            reviewLabel.font = UIFont.systemFont(ofSize: 14)
            reviewLabel.numberOfLines = 0
            addSubview(reviewLabel)
            
            // Configure rating label
            ratingLabel.translatesAutoresizingMaskIntoConstraints = false
            ratingLabel.font = UIFont.systemFont(ofSize: 16)
            ratingLabel.textColor = UIColor.green
            addSubview(ratingLabel)
            
            // Set up constraints
            NSLayoutConstraint.activate([
                avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                avatarImageView.widthAnchor.constraint(equalToConstant: 40),
                avatarImageView.heightAnchor.constraint(equalToConstant: 40),
                
                usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
                usernameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
                
                reviewLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
                reviewLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5),
                reviewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                
                ratingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                ratingLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10)
            ])
        }

        func configure(with review: Review) {
            avatarImageView.image = review.avatar
            usernameLabel.text = review.username
            reviewLabel.text = review.text
            ratingLabel.text = String(review.rating)
        }
    

    

}


struct Review {
    let avatar: UIImage
    let username: String
    let text: String
    let rating: Float
}
