//
//  DetailViewController.swift
//  FilmValley
//
//  Created by Trịnh Kiết Tường on 09/04/2024.
//

import UIKit
import WebKit
import FirebaseAuth
import UIKit
import AVKit
import AVFoundation

class DetailViewController: UIViewController {
    
    let detailVM = DetailViewModel()
    let rateVM = RateViewViewModels()
    var playerViewController: AVPlayerViewController?
    var player: AVPlayer?
    
    var click: Bool = false
    
    private var film: Film
    
    
    init(film: Film) {
        self.film = film
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -UI
    
    private var filmBackground: UIImageView = {
        var filmBackground = UIImageView()
        filmBackground.translatesAutoresizingMaskIntoConstraints = false
        return filmBackground
    }()
    
    private var filmPanel: UIImageView = {
        var filmPanel = UIImageView()
        filmPanel.translatesAutoresizingMaskIntoConstraints = false
        filmPanel.contentMode = .scaleAspectFill
        filmPanel.layer.borderWidth = 1
        filmPanel.layer.cornerRadius = 10
        filmPanel.layer.borderColor = UIColor.white.cgColor
        filmPanel.layer.masksToBounds = true
        return filmPanel
    }()
    
    private var filmTitle: UILabel = {
        var filmTitle = UILabel()
        filmTitle.translatesAutoresizingMaskIntoConstraints = false
        filmTitle.numberOfLines = 0
        filmTitle.font = UIFont(name: "Impact", size: 35)
        return filmTitle
    }()
    
    private var filmDirector: UILabel = {
        var filmDirector = UILabel()
        filmDirector.translatesAutoresizingMaskIntoConstraints = false
        filmDirector.numberOfLines = 0
        filmDirector.textColor = .systemGray
        return filmDirector
    }()
    
    private var filmYear: UILabel = {
        var filmYear = UILabel()
        filmYear.translatesAutoresizingMaskIntoConstraints = false
        filmYear.textColor = UIColor.darkGray
        filmYear.font = UIFont(name: "HelveticaNeue-BoldItalic", size: 18)
        return filmYear
    }()
    
    private var playFilmBtn: UIButton = {
        let playFilmBtn = UIButton()
        playFilmBtn.translatesAutoresizingMaskIntoConstraints = false
        playFilmBtn.configuration = .filled()
        playFilmBtn.configuration?.baseBackgroundColor = UIColor(red: 0.525, green: 0.639, blue: 0.78, alpha: 1)
        playFilmBtn.layer.cornerRadius = 10
        let title = AttributedString("Watch", attributes: AttributeContainer([.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 12, weight: .semibold)]))
        playFilmBtn.configuration?.attributedTitle = title
        playFilmBtn.configuration?.image = UIImage(systemName: "play.fill")
        playFilmBtn.configuration?.baseForegroundColor = .white
        playFilmBtn.configuration?.imagePlacement = .trailing
        return playFilmBtn
    }()
    
    private lazy var rateAvgBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        var config = UIButton.Configuration.tinted()
        let image = UIImage(systemName: "star.fill")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        config.image = image
        config.imagePlacement = .leading
        config.imagePadding = 5
        config.baseBackgroundColor = .systemGray4
        config.subtitle = "View statistical"
        
        
        let titleColor: UIColor
        let subtitleColor: UIColor
        
        if self.traitCollection.userInterfaceStyle == .dark {
            titleColor = .white
            subtitleColor = .white
        } else {
            titleColor = .black
            subtitleColor = .black
        }
        let title = AttributedString("0.0", attributes: AttributeContainer([.foregroundColor: titleColor, .font: UIFont.systemFont(ofSize: 16, weight: .bold)]))
        let subtitle = AttributedString("View statistical", attributes: AttributeContainer([.foregroundColor: subtitleColor]))
        
        config.attributedTitle = title
        config.attributedSubtitle = subtitle
        
        button.configuration = config
        return button
    }()
    
    
    private var dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray3
        return view
    }()
    
    private var filmDes: UITextView = {
        let filmDes = UITextView()
        filmDes.translatesAutoresizingMaskIntoConstraints = false
        filmDes.textColor = .systemGray
        filmDes.isEditable = false
        filmDes.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return filmDes
    }()
    
    private var dividerView2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray3
        return view
    }()
    
    
    private var cast_genres_view: UIView = {
        let uiview = UIView()
        uiview.translatesAutoresizingMaskIntoConstraints = false
        return uiview
    }()
    
    private var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.layer.borderWidth = 1
        webView.layer.borderColor = UIColor.systemGray3.cgColor
        webView.scrollView.isScrollEnabled = true
        return webView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var favButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        let image = UIImage(systemName: "heart.fill")
        let pinkImage = image?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        button.setImage(pinkImage, for: .normal)
        button.layer.borderColor = UIColor.systemGray2.cgColor
        return button
    }()
    
    private var favButtonClicked: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 10
        let image = UIImage(systemName: "heart.fill")
        let pinkImage = image?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(pinkImage, for: .normal)
        return button
    }()
    
    private var rateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        var config = UIButton.Configuration.filled()
        let image = UIImage(systemName: "eyes.inverse")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        config.image = image
        config.imagePlacement = .trailing
        config.baseBackgroundColor = UIColor(red: 0.259, green: 0.722, blue: 0.878, alpha: 1)
        
        let title = AttributedString("Rate", attributes: AttributeContainer([.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 14, weight: .semibold)]))
        config.attributedTitle = title
        
        button.configuration = config
        return button
    }()
    
    private var ListReviewBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        var config = UIButton.Configuration.filled()
        config.titleAlignment = .leading
        let image = UIImage(systemName: "tray.full.fill")
        config.image = image
        config.imagePlacement = .trailing
        config.imagePadding = 6
        config.baseBackgroundColor = UIColor(red: 0.42, green: 0.741, blue: 0.235, alpha: 1)
        let title = AttributedString("List of all reviews for this movie", attributes: AttributeContainer([.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 15, weight: .semibold)]))
        config.attributedTitle = title
        button.configuration = config
        return button
    }()
    
    //MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        //NavBar
        navigationController?.navigationBar.tintColor = .systemCyan
        let backImage = UIImage(systemName: "chevron.backward.circle.fill")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        
        SetUp()
        addChildCastGenresView()
        
        print("Genres: \(film.genres)")
        print("Casts: \(film.cast)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        favButton.layer.cornerRadius = favButton.frame.height/2
        favButtonClicked.layer.cornerRadius = favButtonClicked.frame.height / 2
    }
    
    //MARK: -SetUp
    private func SetUp(){
        
        view.addSubview(scrollView)
        scrollView.addSubview(filmBackground)
        scrollView.addSubview(filmPanel)
        scrollView.addSubview(filmTitle)
        scrollView.addSubview(filmDirector)
        scrollView.addSubview(filmYear)
        scrollView.addSubview(playFilmBtn)
        scrollView.addSubview(rateAvgBtn)
        scrollView.addSubview(dividerView)
        scrollView.addSubview(filmDes)
        scrollView.addSubview(dividerView2)
        scrollView.addSubview(cast_genres_view)
        scrollView.addSubview(webView)
        scrollView.addSubview(rateButton)
        scrollView.addSubview(ListReviewBtn)
        
        filmBackground.downloaded(from: film.background)
        filmPanel.downloaded(from: film.imageUrl)
        filmTitle.text = film.title
        filmDirector.text = "Directed By \(film.director)"
        filmYear.text = String(film.year)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        
        let attributedText = NSMutableAttributedString(
            string: "Description:\n\n" + film.des,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: UIFont.systemFont(ofSize: 14, weight: .semibold),
                .foregroundColor: UIColor.systemGray
            ]
        )
        
        filmDes.attributedText = attributedText
        
        
        
        //Trailer_WV
        let videoID = film.trailer
        let embedURLString = "https://www.youtube.com/embed/\(videoID)?controls=0&showinfo=0&rel=0"
        if let embedURL = URL(string: embedURLString) {
            let request = URLRequest(url: embedURL)
            webView.load(request)
        }
        
        //BtnWatchMovie:
        playFilmBtn.addTarget(self, action: #selector(playFilmButtonTapped), for: .touchUpInside)
        
        //ChartButton
        rateAvgBtn.addTarget(self, action: #selector(rateAvgBtnTapped), for: .touchUpInside)
        
        detailVM.getData(filmID: film.id) { data in
            self.detailVM.dataArr = data
            self.detailVM.getPoint(data: self.detailVM.dataArr) { points in
                // Assuming points are already in the range of 1 to 10
                var totalRatings = 0
                var totalPoints = 0.0

                for (rating, count) in self.detailVM.chartData {
                    totalRatings += count
                    totalPoints += Double(rating * count)
                }

                let average: Double
                if totalRatings == 0 {
                    average = 0.0
                } else {
                    average = totalPoints / Double(totalRatings)
                }
                
                let formattedAvg = String(format: "%.1f", average)

                let titleColor: UIColor
                if self.traitCollection.userInterfaceStyle == .dark {
                    titleColor = .white
                } else {
                    titleColor = .black
                }

                let title = AttributedString(formattedAvg, attributes: AttributeContainer([.foregroundColor: titleColor, .font: UIFont.systemFont(ofSize: 16, weight: .bold)]))
                self.rateAvgBtn.configuration?.attributedTitle = title
            }
        }

        
        //favButton
        detailVM.check(idFilm: film.id){result in
            print(result)
            self.click = result
            if self.click {
                DispatchQueue.main.async {
                    self.view.addSubview(self.favButtonClicked)
                    self.favButton.removeFromSuperview()
                    self.setUpConstraints(for: self.favButtonClicked)
                }
            } else {
                DispatchQueue.main.async {
                    self.view.addSubview(self.favButton)
                    self.favButtonClicked.removeFromSuperview()
                    self.setUpConstraints(for: self.favButton)
                }
            }
        }
        
        //rateButton
        let userID = Auth.auth().currentUser?.uid
        rateVM.hasUserReviewedFilm(userID: userID!, filmID: film.id) { hasReviewed, rating, comment in
            if hasReviewed {
                let image = UIImage(systemName: "pencil.line")?.withTintColor(.white, renderingMode: .alwaysOriginal)
                self.rateButton.configuration?.image = image
                self.rateButton.configuration?.attributedTitle = AttributedString("Rerate", attributes: AttributeContainer([.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 13, weight: .semibold)]))
                self.rateButton.configuration?.baseBackgroundColor = .systemOrange
            }
        }
        
        favButton.addTarget(self, action: #selector(favBtnTapped), for: .touchUpInside)
        favButtonClicked.addTarget(self, action: #selector(favBtnTapped), for: .touchUpInside)
        
        rateButton.addTarget(self, action: #selector(tappedRateBtn), for: .touchUpInside)
        ListReviewBtn.addTarget(self, action: #selector(tappedListReviewBtn), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            scrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            filmBackground.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            filmBackground.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            filmBackground.centerYAnchor.constraint(equalTo: scrollView.topAnchor, constant: -40),
            
            filmPanel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 117),
            filmPanel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            filmPanel.widthAnchor.constraint(equalToConstant: 120),
            filmPanel.heightAnchor.constraint(equalToConstant: 180),
            
            filmTitle.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            filmTitle.trailingAnchor.constraint(equalTo: filmPanel.leadingAnchor, constant: -15),
            filmTitle.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 80),
            
            filmDirector.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            filmDirector.trailingAnchor.constraint(equalTo: filmPanel.leadingAnchor, constant: -20),
            filmDirector.topAnchor.constraint(equalTo: filmTitle.bottomAnchor, constant: 5),
            
            filmYear.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            filmYear.trailingAnchor.constraint(equalTo: filmPanel.leadingAnchor, constant: -20),
            filmYear.topAnchor.constraint(equalTo: filmDirector.bottomAnchor, constant: 5),
            
            playFilmBtn.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            playFilmBtn.topAnchor.constraint(equalTo: filmYear.bottomAnchor, constant: 12),
            playFilmBtn.heightAnchor.constraint(equalToConstant: 37),
            playFilmBtn.widthAnchor.constraint(equalToConstant: 85),
            
            rateAvgBtn.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,constant: 20),
            rateAvgBtn.topAnchor.constraint(equalTo: playFilmBtn.bottomAnchor, constant: 16),
            rateAvgBtn.heightAnchor.constraint(equalToConstant: 48),
            rateAvgBtn.widthAnchor.constraint(equalToConstant: 148),
            
            dividerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            dividerView.topAnchor.constraint(equalTo: rateAvgBtn.bottomAnchor, constant: 14),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            cast_genres_view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            cast_genres_view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,constant: 0),
            cast_genres_view.topAnchor.constraint(equalTo: dividerView.bottomAnchor,constant: 13),
            cast_genres_view.heightAnchor.constraint(equalToConstant: 90),
            
            dividerView2.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            dividerView2.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            dividerView2.topAnchor.constraint(equalTo: cast_genres_view.bottomAnchor, constant: 17),
            dividerView2.heightAnchor.constraint(equalToConstant:0.5),
            
            filmDes.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 13),
            filmDes.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -13),
            filmDes.topAnchor.constraint(equalTo: dividerView2.bottomAnchor, constant: 10),
            filmDes.heightAnchor.constraint(equalToConstant: 150),
            
            webView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            webView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            webView.topAnchor.constraint(equalTo: filmDes.bottomAnchor, constant: 25),
            webView.heightAnchor.constraint(equalToConstant: 150),
            
            rateButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            rateButton.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            rateButton.widthAnchor.constraint(equalToConstant: 93),
            rateButton.heightAnchor.constraint(equalToConstant: 57),
            rateButton.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            
            ListReviewBtn.leadingAnchor.constraint(equalTo: rateButton.trailingAnchor, constant: 10),
            ListReviewBtn.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            ListReviewBtn.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            ListReviewBtn.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func setUpConstraints(for button: UIButton) {
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 44),
            button.widthAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func addChildCastGenresView(){
        let cast_genresVw = CastGenresViewController(casts: film.cast, genres: film.genres)
        
        addChild(cast_genresVw)
        
        cast_genres_view.addSubview(cast_genresVw.view)
        
        cast_genresVw.didMove(toParent: self)
        
        cast_genresVw.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cast_genresVw.view.leadingAnchor.constraint(equalTo: cast_genres_view.leadingAnchor),
            cast_genresVw.view.trailingAnchor.constraint(equalTo: cast_genres_view.trailingAnchor),
            cast_genresVw.view.topAnchor.constraint(equalTo: cast_genres_view.topAnchor),
            cast_genresVw.view.bottomAnchor.constraint(equalTo: cast_genres_view.bottomAnchor)
        ])
    }
    
    //MARK: -Actions
    
    @objc func favBtnTapped(){
        click = !click
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 0.1
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = 0.8
        scaleAnimation.autoreverses = true
        favButton.layer.add(scaleAnimation, forKey: "scale")
        favButtonClicked.layer.add(scaleAnimation, forKey: "scale")
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.duration = 0.1
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0.5
        opacityAnimation.autoreverses = true
        favButton.layer.add(opacityAnimation, forKey: "opacity")
        favButtonClicked.layer.add(opacityAnimation, forKey: "opacity")
        
        if click {
            favButton.removeFromSuperview()
            view.addSubview(favButtonClicked)
            setUpConstraints(for: favButtonClicked)
            detailVM.addFilmToFavouriteList(idFilm: film.id)
            let alert = UIAlertController(title: "", message: "Added film to favourites list!", preferredStyle: .alert)
            alert.setMessage(font: UIFont.systemFont(ofSize: 14), color: .systemGreen)
            self.present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                alert.dismiss(animated: true)
            }
        } else {
            favButtonClicked.removeFromSuperview()
            view.addSubview(favButton)
            setUpConstraints(for: favButton)
            detailVM.removeFilmFromFavouriteList(idFilm: film.id)
            let alert = UIAlertController(title: "", message: "Removed film to favourites list!", preferredStyle: .alert)
            alert.setMessage(font: UIFont.systemFont(ofSize: 14), color: .systemRed)
            self.present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                alert.dismiss(animated: true)
            }
        }
        print(click)
    }
    
    @objc private func tappedRateBtn(){
        let rateView = RateViewController(film: film)
        if let sheet = rateView.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = CGFloat(35)
        }
        present(rateView, animated: true, completion: nil)
    }
    
    @objc private func tappedListReviewBtn(){
        let lstComment = ListCommentViewController(idFilm: film.id)
        if let sheet = lstComment.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = CGFloat(35)
        }
        present(lstComment, animated: true, completion: nil)
    }
    
    @objc private func playFilmButtonTapped() {
        showFilmPlayer()
    }
    
    @objc private func rateAvgBtnTapped(){
        let rateChartVC = RateChartViewController(chartD: detailVM.chartData)
        if let sheet = rateChartVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        present(rateChartVC, animated: true, completion: nil)
    }
    
    
    private func showFilmPlayer() {
        let videoURL = URL(string: film.embed)!
        player = AVPlayer(url: videoURL)
        
        playerViewController = AVPlayerViewController()
        playerViewController?.player = player
        
        if let playerVC = playerViewController {
            present(playerVC, animated: true) {
                playerVC.player?.play()
            }
        }
    }
    
}


extension DetailViewController: AVPlayerViewControllerDelegate {
    func playerViewController(_ playerViewController: AVPlayerViewController, failedToStartPictureInPictureWithError error: Error) {
        print("Failed to start Picture in Picture: \(error.localizedDescription)")
    }
}



