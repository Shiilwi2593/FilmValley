//
//  RateTVShowViewController.swift
//  FilmValley2
//
//  Created by Trịnh Kiết Tường on 25/06/2024.
//

import UIKit
import FirebaseAuth

class RateTVShowViewController: UIViewController {
    
    private var tvShow: TVShows
    
    private var viewModel = RateViewViewModels()
    
    init(tvShow: TVShows){
        self.tvShow = tvShow
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var rating: Int = 1 {
        didSet {
            updateRatePointImageSize()
        }
    }
    
    let ratePointImage: UIImageView = {
        let ratePointImage = UIImageView()
        ratePointImage.translatesAutoresizingMaskIntoConstraints = false
        ratePointImage.image = UIImage(systemName: "star.fill")
        ratePointImage.tintColor = .systemBlue
        return ratePointImage
    }()
    
    let filmName: UILabel = {
        let filmName = UILabel()
        filmName.translatesAutoresizingMaskIntoConstraints = false
        filmName.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return filmName
    }()
    
    let starRatingView: StarRatingView = {
        let starRatingView = StarRatingView()
        starRatingView.translatesAutoresizingMaskIntoConstraints = false
        return starRatingView
    }()
    
    let reviewLabel: UILabel = {
        let reviewLabel = UILabel()
        reviewLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewLabel.text = "Write your thoughts about this TVShow"
        reviewLabel.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        reviewLabel.textColor = .systemGray2
        return reviewLabel
    }()
    
    let reviewBox: UITextView = {
        let reviewBox = UITextView()
        reviewBox.translatesAutoresizingMaskIntoConstraints = false
        reviewBox.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 10, right: 10)
        reviewBox.layer.cornerRadius = 10
        reviewBox.layer.borderWidth = 1
        reviewBox.layer.borderColor = UIColor.systemGray2.cgColor
        reviewBox.textAlignment = .left
        reviewBox.font = UIFont.systemFont(ofSize: 12, weight: .light)
        reviewBox.isScrollEnabled = true
        return reviewBox
    }()
    
    let submitButton: UIButton = {
        let submitBtn = UIButton()
        submitBtn.translatesAutoresizingMaskIntoConstraints = false
        submitBtn.configuration = .filled()
        submitBtn.configuration?.baseForegroundColor = .systemGray6
        submitBtn.configuration?.image = UIImage(systemName: "paperplane.fill")
        submitBtn.configuration?.imagePadding = 6
        submitBtn.configuration?.imagePlacement = .trailing
        submitBtn.configuration?.baseBackgroundColor = .systemBlue
        return submitBtn
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUp()
        
    }
    
    private func setUp(){
        view.addSubview(ratePointImage)
        view.addSubview(filmName)
        view.addSubview(starRatingView)
        view.addSubview(reviewLabel)
        view.addSubview(reviewBox)
        view.addSubview(submitButton)
        
        let id = tvShow.id
        print(id)
        let userID = Auth.auth().currentUser?.uid ?? ""
        print(userID)
        
        viewModel.hasUserReviewedFilm(userID: userID, filmID: tvShow.id) { hasReviewed, rating, comment in
            if hasReviewed {
                print("Da review phim nay roi")
                print("Rating: \(rating ?? 0)")
                self.rating = rating ?? 0
                self.starRatingView.rating = self.rating
                self.reviewBox.text = comment
                
            } else {
                print("Chua review phim nay")
            }
        }
        
        starRatingView.ratingDidChange = {rating in
            print(rating)
            self.rating = rating
        }
        
        filmName.text = tvShow.title
        
        submitButton.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            ratePointImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ratePointImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            ratePointImage.heightAnchor.constraint(equalToConstant: 80),
            ratePointImage.widthAnchor.constraint(equalToConstant: 80),
            
            filmName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filmName.topAnchor.constraint(equalTo: ratePointImage.bottomAnchor, constant: 8),
            
            starRatingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starRatingView.topAnchor.constraint(equalTo: filmName.bottomAnchor, constant: 8),
            starRatingView.widthAnchor.constraint(equalToConstant: 300),
            starRatingView.heightAnchor.constraint(equalToConstant: 40),
            
            reviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 37),
            reviewLabel.topAnchor.constraint(equalTo: starRatingView.bottomAnchor, constant: 10),
            
            reviewBox.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reviewBox.topAnchor.constraint(equalTo: reviewLabel.bottomAnchor, constant: 10),
            reviewBox.widthAnchor.constraint(equalToConstant: 320),
            reviewBox.heightAnchor.constraint(equalToConstant: 120),
            
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.topAnchor.constraint(equalTo: reviewBox.bottomAnchor,constant: 16),
            submitButton.widthAnchor.constraint(equalToConstant: 60),
            submitButton.heightAnchor.constraint(equalToConstant: 35)
            
        ])
        
    }
    
    private func updateRatePointImageSize() {
        let imageSize: CGFloat = CGFloat(rating) * 10
        let scale = imageSize / 80
        ratePointImage.transform = CGAffineTransform(scaleX: imageSize / 80, y: imageSize / 80)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.ratePointImage.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: nil)
    }
    
    @objc private func didTapSubmitButton(){
        viewModel.StoreTVShowReview(idTVShow: tvShow.id, ratePoint: self.rating, Comment: reviewBox.text)
        let alert = UIAlertController(title: "", message: "Your comment is in. We value your thoughts!", preferredStyle: .alert)
        alert.setMessage(font: UIFont.systemFont(ofSize: 14), color: .systemGreen)
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alert.dismiss(animated: true) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}





