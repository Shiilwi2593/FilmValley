//
//  ListCommentViewController.swift
//  FilmValley2
//
//  Created by Trịnh Kiết Tường on 24/05/2024.
//

import UIKit

class ListCommentViewController: UIViewController{
    
    let idFilm: String
    let rateViewVM = RateViewViewModels()
    var reviews: [Review] = []
    
    init(idFilm: String) {
        self.idFilm = idFilm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    private let headLbl: UILabel = {
        let headLbl = UILabel()
        headLbl.translatesAutoresizingMaskIntoConstraints = false
        headLbl.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return headLbl
    }()
    
    private let tableView: UITableView = {
        let tableVw = UITableView()
        tableVw.translatesAutoresizingMaskIntoConstraints = false
        tableVw.register(ReviewCell.self, forCellReuseIdentifier: "ReviewCell")
        return tableVw
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(headLbl)
        tableView.delegate = self
        tableView.dataSource = self
        fetchComments(for: idFilm)
        
        NSLayoutConstraint.activate([
            headLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 13 ),
            headLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            headLbl.heightAnchor.constraint(equalToConstant: 15),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -13),
            tableView.topAnchor.constraint(equalTo: headLbl.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    private func fetchComments(for idFilm: String) {
        rateViewVM.getListComment(idFilm: idFilm) { [weak self] reviews in
            
            self?.reviews = reviews
            
            let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
            
            let attributedMessage = NSMutableAttributedString(
                string: "Loading...",
                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
            )
            alert.setValue(attributedMessage, forKey: "attributedMessage")
            
            let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            indicator.center = CGPoint(x: alert.view.bounds.midX, y: alert.view.bounds.midY)
            indicator.hidesWhenStopped = true
            indicator.style = UIActivityIndicatorView.Style.medium
            indicator.startAnimating()
            
            alert.view.addSubview(indicator)
            
            self?.present(alert, animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                alert.dismiss(animated: true)
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.headLbl.text = "Reviews(\(reviews.count))"
            }
        }
    }
}

extension ListCommentViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let review = reviews[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        
        cell.commentText.text = review.comment
        
        rateViewVM.getUsernameFromID(idUser: review.idUser) { username in
            DispatchQueue.main.async {
                cell.username.text = username
            }
        }
        rateViewVM.getImageFromId(idUser: review.idUser) { url in
            let imageUrl = url
            self.rateViewVM.loadImage(from: imageUrl) { image in
                cell.avatar.image = image
            }
            
        }
        cell.timeStamp.text = review.timeStamp
        
        let ratingImages = [
            "01.circle.fill",
            "02.circle.fill",
            "03.circle.fill",
            "04.circle.fill",
            "05.circle.fill",
            "06.circle.fill",
            "07.circle.fill",
            "08.circle.fill",
            "09.circle.fill",
            "10.circle.fill"
        ]
        if (1...10).contains(review.ratePoint) {
            let index = review.ratePoint - 1
            let imageName = ratingImages[index]
            cell.rating.image = UIImage(systemName: imageName)
        }
        
        if (1...4).contains(review.ratePoint){
            cell.rating.tintColor = UIColor(red: 0.82, green: 0.31, blue: 0.149, alpha: 1)
        } else if (5...7).contains(review.ratePoint){
            cell.rating.tintColor = UIColor(red: 0.878, green: 0.859, blue: 0.082, alpha: 1)
        } else{
            cell.rating.tintColor = UIColor(red: 0.353, green: 0.82, blue: 0.129, alpha: 1)
            addPulseAnimation(to: cell.rating)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedReview = reviews[indexPath.row]
        let idUser = selectedReview.idUser
        let review = reviews[indexPath.row]
        let comment = review.comment
        
        rateViewVM.getInfoUserByID(idUser: idUser) { [weak self] userInfo in
            guard let self = self, let userInfo = userInfo else { return }
            
            DispatchQueue.main.async {
                let userInfoView = UserInfo(frame: .zero)
                userInfoView.translatesAutoresizingMaskIntoConstraints = false
                userInfoView.configure(with: userInfo, review: comment)
                
                self.view.addSubview(userInfoView)
                
                NSLayoutConstraint.activate([
                    userInfoView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                    userInfoView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                    userInfoView.widthAnchor.constraint(equalToConstant: 300),
                    userInfoView.heightAnchor.constraint(equalToConstant: 250)
                ])
                
                // Apply scale animation from small to normal size
                userInfoView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
                    userInfoView.transform = CGAffineTransform.identity
                }, completion: nil)
                
                // Add tap gesture to dismiss the view
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissUserInfoView(_:)))
                self.view.addGestureRecognizer(tapGesture)
            }
        }
    }
    
    @objc private func dismissUserInfoView(_ sender: UITapGestureRecognizer) {
        for subview in self.view.subviews {
            if subview is UserInfo {
                subview.removeFromSuperview()
            }
        }
        self.view.gestureRecognizers?.forEach(self.view.removeGestureRecognizer)
    }
    
    func addPulseAnimation(to view: UIView) {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 0.5
        pulseAnimation.fromValue = 0.95
        pulseAnimation.toValue = 1.05
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        view.layer.add(pulseAnimation, forKey: "pulse")
    }
}




