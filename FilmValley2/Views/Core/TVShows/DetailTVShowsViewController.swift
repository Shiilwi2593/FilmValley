//
//  DetailTVShowsViewController.swift
//  FilmValley2
//
//  Created by Trịnh Kiết Tường on 19/06/2024.
//

import UIKit
import WebKit
import FirebaseAuth
class DetailTVShowsViewController: UIViewController {
    
    private var tvShow: TVShows
    let detailVM = DetailViewModel()
    let rateVM = RateViewViewModels()

    
    var episodeLinks = [""]
    
    init(tvShow: TVShows){
        self.tvShow = tvShow
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - UI
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var background: UIImageView = {
        let background = UIImageView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.contentMode = .scaleToFill
        return background
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
        let filmTitle = UILabel()
        filmTitle.translatesAutoresizingMaskIntoConstraints = false
        filmTitle.font = UIFont(name: "impact", size: 30)
        filmTitle.numberOfLines = 3
        return filmTitle
    }()
    
    private var creatorTitle: UILabel = {
        let creator = UILabel()
        creator.translatesAutoresizingMaskIntoConstraints = false
        creator.numberOfLines = 0
        creator.font = UIFont.systemFont(ofSize: 15)
        creator.textColor = .systemGray
        return creator
    }()
    
    private var yearTitle: UILabel = {
        var yearTitle = UILabel()
        yearTitle.translatesAutoresizingMaskIntoConstraints = false
        yearTitle.textColor = UIColor.darkGray
        yearTitle.font = UIFont(name: "HelveticaNeue-BoldItalic", size: 15)
        return yearTitle
    }()
    
    private var trailerBtn: UIButton = {
        let trailerBtn = UIButton()
        trailerBtn.translatesAutoresizingMaskIntoConstraints = false
        trailerBtn.configuration = .filled()
        trailerBtn.configuration?.baseBackgroundColor = UIColor(hex: "#DEA2A2")
        trailerBtn.configuration?.baseForegroundColor = .white
        trailerBtn.layer.cornerRadius = 10
        let title = AttributedString("Trailer", attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: 14, weight: .semibold)]))
        trailerBtn.configuration?.attributedTitle = title
        trailerBtn.configuration?.image = UIImage(systemName: "play.fill")
        trailerBtn.configuration?.imagePlacement = .trailing
        trailerBtn.configuration?.imagePadding = 5
        return trailerBtn
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
    
    private var divider1: UIView = {
        let divider1 = UIView()
        divider1.translatesAutoresizingMaskIntoConstraints = false
        divider1.layer.borderWidth = 1
        divider1.layer.borderColor = UIColor.systemGray3.cgColor
        return divider1
    }()
    
    private var espisodeTitle: UILabel = {
        let espisodeTitle = UILabel()
        espisodeTitle.translatesAutoresizingMaskIntoConstraints = false
        espisodeTitle.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        espisodeTitle.textColor = .systemGray
        return espisodeTitle
    }()
    
    private var episodeScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var episodeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually  // Adjust distribution as per your design
        return stackView
    }()

    
    private var divider2: UIView = {
        let divider2 = UIView()
        divider2.translatesAutoresizingMaskIntoConstraints = false
        divider2.layer.borderColor = UIColor.systemGray3.cgColor
        divider2.layer.borderWidth = 1
        return divider2
    }()
    
    private var cast_genres_view: UIView = {
        let uiview = UIView()
        uiview.translatesAutoresizingMaskIntoConstraints = false
        return uiview
    }()
    
    private var divider3: UIView = {
        let divider3 = UIView()
        divider3.translatesAutoresizingMaskIntoConstraints = false
        return divider3
    }()
    
    private var filmDes: UITextView = {
        let filmDes = UITextView()
        filmDes.translatesAutoresizingMaskIntoConstraints = false
        filmDes.textColor = .systemGray
        filmDes.isEditable = false
        filmDes.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return filmDes
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
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.titleView?.isHidden = true
        addChildCastGenresView()
        setUp()
    }
    
    // MARK: - SetUp
    private func setUp() {
        view.addSubview(scrollView)
        scrollView.addSubview(background)
        scrollView.addSubview(filmPanel)
        scrollView.addSubview(filmTitle)
        scrollView.addSubview(creatorTitle)
        scrollView.addSubview(yearTitle)
        scrollView.addSubview(trailerBtn)
        scrollView.addSubview(rateAvgBtn)
        scrollView.addSubview(episodeScrollView)
        scrollView.addSubview(divider1)
        scrollView.addSubview(espisodeTitle)
        scrollView.addSubview(divider2)
        scrollView.addSubview(cast_genres_view)
        scrollView.addSubview(filmDes)
        scrollView.addSubview(rateButton)
        scrollView.addSubview(ListReviewBtn)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        
        let attributedText = NSMutableAttributedString(
            string: "Description:\n" + self.tvShow.des
            ,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: UIFont.systemFont(ofSize: 14, weight: .semibold),
                .foregroundColor: UIColor.systemGray
            ]
        )
        
        filmDes.attributedText = attributedText
        
        self.episodeLinks = tvShow.embed
        
        episodeScrollView.addSubview(episodeStackView)
        
        for i in 1...episodeLinks.count {
            let button = UIButton(type: .system)
            button.setTitle(" Episode \(i) ", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
            button.backgroundColor = UIColor(hex: "#F4A460")
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 5
            button.tag = i - 1
            button.addTarget(self, action: #selector(playEpisode), for: .touchUpInside)
            episodeStackView.addArrangedSubview(button)
        }
        
        background.downloaded(from: tvShow.background, contentMode: .scaleToFill)
        filmPanel.downloaded(from: tvShow.imageUrl, contentMode: .scaleToFill)
        filmTitle.text = tvShow.title
        creatorTitle.text = "Created by \(tvShow.creator)"
        espisodeTitle.text = "\(self.episodeLinks.count) espisodes"
        
        trailerBtn.addTarget(self, action: #selector(trailerBtnTapped), for: .touchUpInside)
        
        
        //rateButton
        let userID = Auth.auth().currentUser?.uid
        rateVM.hasUserReviewedFilm(userID: userID!, filmID: tvShow.id) { hasReviewed, rating, comment in
            if hasReviewed {
                let image = UIImage(systemName: "pencil.line")?.withTintColor(.white, renderingMode: .alwaysOriginal)
                self.rateButton.configuration?.image = image
                self.rateButton.configuration?.attributedTitle = AttributedString("Rerate", attributes: AttributeContainer([.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 13, weight: .semibold)]))
                self.rateButton.configuration?.baseBackgroundColor = .systemOrange
            }
        }
        rateButton.addTarget(self, action: #selector(tappedRateBtn), for: .touchUpInside)
        ListReviewBtn.addTarget(self, action: #selector(tappedListReviewBtn), for: .touchUpInside)

        NSLayoutConstraint.activate([
            scrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            background.topAnchor.constraint(equalTo: scrollView.topAnchor,constant: -98),
            background.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            background.heightAnchor.constraint(equalToConstant: 190),
            
            filmPanel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            filmPanel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 45),
            filmPanel.widthAnchor.constraint(equalToConstant: 134),
            filmPanel.heightAnchor.constraint(equalToConstant: 177),
            
            filmTitle.leadingAnchor.constraint(equalTo: filmPanel.trailingAnchor, constant: 14),
            filmTitle.topAnchor.constraint(equalTo: background.bottomAnchor, constant: 10),
            filmTitle.widthAnchor.constraint(equalToConstant: 220),
            
            creatorTitle.leadingAnchor.constraint(equalTo: filmPanel.trailingAnchor, constant: 14),
            creatorTitle.topAnchor.constraint(equalTo: filmTitle.bottomAnchor, constant: 10),
            
            trailerBtn.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            trailerBtn.topAnchor.constraint(equalTo: filmPanel.bottomAnchor, constant: 10),
            trailerBtn.heightAnchor.constraint(equalToConstant: 35),
            trailerBtn.widthAnchor.constraint(equalToConstant: 92),
            
            rateAvgBtn.topAnchor.constraint(equalTo: trailerBtn.bottomAnchor, constant: 10),
            rateAvgBtn.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            rateAvgBtn.heightAnchor.constraint(equalToConstant: 48),
            rateAvgBtn.widthAnchor.constraint(equalToConstant: 148),
            
            divider1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,constant: 10),
            divider1.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            divider1.topAnchor.constraint(equalTo: rateAvgBtn.bottomAnchor, constant: 12),
            divider1.heightAnchor.constraint(equalToConstant: 1),
            
            espisodeTitle.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            espisodeTitle.topAnchor.constraint(equalTo: divider1.bottomAnchor, constant: 14),
            
            episodeScrollView.topAnchor.constraint(equalTo: espisodeTitle.bottomAnchor, constant: 7),
            episodeScrollView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            episodeScrollView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            episodeScrollView.heightAnchor.constraint(equalToConstant: 40),
            
            episodeStackView.topAnchor.constraint(equalTo: episodeScrollView.topAnchor),
            episodeStackView.leadingAnchor.constraint(equalTo: episodeScrollView.leadingAnchor),
            episodeStackView.trailingAnchor.constraint(equalTo: episodeScrollView.trailingAnchor),
            episodeStackView.bottomAnchor.constraint(equalTo: episodeScrollView.bottomAnchor),
            episodeStackView.heightAnchor.constraint(equalTo: episodeScrollView.heightAnchor),
            
            divider2.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,constant: 10),
            divider2.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            divider2.topAnchor.constraint(equalTo: episodeScrollView.bottomAnchor, constant: 18),
            divider2.heightAnchor.constraint(equalToConstant: 1),
            
            cast_genres_view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,constant: 8),
            cast_genres_view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,constant: -8),
            cast_genres_view.topAnchor.constraint(equalTo: divider2.bottomAnchor,constant: 10),
            cast_genres_view.heightAnchor.constraint(equalToConstant: 80),
            
            filmDes.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            filmDes.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            filmDes.topAnchor.constraint(equalTo: cast_genres_view.bottomAnchor, constant: 12),
            filmDes.heightAnchor.constraint(equalToConstant: 100),
            
            rateButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            rateButton.topAnchor.constraint(equalTo: filmDes.bottomAnchor, constant: 10),
            rateButton.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            rateButton.widthAnchor.constraint(equalToConstant: 93),
            rateButton.heightAnchor.constraint(equalToConstant: 57),
            
            ListReviewBtn.leadingAnchor.constraint(equalTo: rateButton.trailingAnchor, constant: 10),
            ListReviewBtn.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            ListReviewBtn.topAnchor.constraint(equalTo: filmDes.bottomAnchor, constant: 10),
            ListReviewBtn.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            ListReviewBtn.heightAnchor.constraint(equalToConstant: 57)
        ])
    }
    
    private func addChildCastGenresView(){
        let cast_genresVw = CastGenresViewController(casts: tvShow.cast, genres: tvShow.genres)
        
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
    
    @objc private func playEpisode(sender: UIButton) {
        let url = episodeLinks[sender.tag]
        let webViewController = WebViewController()
        webViewController.urlString = url
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    @objc private func trailerBtnTapped() {
        let youtubeEmbedBaseUrl = "https://www.youtube.com/embed/"
        let youtubeUrl = youtubeEmbedBaseUrl + tvShow.trailer
        let webViewController = WebViewController()
        webViewController.urlString = youtubeUrl
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    @objc private func tappedRateBtn(){
        let rateView = RateTVShowViewController(tvShow:tvShow)
        if let sheet = rateView.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = CGFloat(35)
        }
        present(rateView, animated: true, completion: nil)
    }
    
    @objc private func tappedListReviewBtn(){
        let lstComment = ListCommentViewController(idFilm: tvShow.id)
        if let sheet = lstComment.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = CGFloat(35)
        }
        present(lstComment, animated: true, completion: nil)
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
    
    

}

class WebViewController: UIViewController {
    var urlString: String?
    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: view.frame)
        view.addSubview(webView)
        
        if let urlString = urlString, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
