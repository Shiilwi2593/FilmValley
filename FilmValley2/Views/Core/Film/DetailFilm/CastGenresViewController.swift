import UIKit

class CastGenresViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var genres: [String]
    private var casts: [String]
    private var currentData = [String]()
    private var selectedLabel: UILabel?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
        return collectionView
    }()
    
    init(casts: [String], genres: [String]) {
        self.casts = casts
        self.genres = genres
        super.init(nibName: nil, bundle: nil)
        currentData = casts // Initial data to display
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTopNavigationBar()
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupTopNavigationBar() {
        let castLabel = UILabel()
        castLabel.translatesAutoresizingMaskIntoConstraints = false
        castLabel.text = "CAST"
        castLabel.textColor = .systemGray
        castLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        castLabel.isUserInteractionEnabled = true
        let castTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        castLabel.addGestureRecognizer(castTapGesture)
        view.addSubview(castLabel)
        
        let genresLabel = UILabel()
        genresLabel.translatesAutoresizingMaskIntoConstraints = false
        genresLabel.text = "GENRES"
        genresLabel.textColor = .systemGray
        genresLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        genresLabel.isUserInteractionEnabled = true
        let genresTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        genresLabel.addGestureRecognizer(genresTapGesture)
        view.addSubview(genresLabel)
        
        selectedLabel = castLabel
        let attributedString = NSMutableAttributedString(string: selectedLabel!.text!)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        selectedLabel!.attributedText = attributedString
        
        NSLayoutConstraint.activate([
            castLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            castLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            genresLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            genresLabel.leadingAnchor.constraint(equalTo: castLabel.trailingAnchor, constant: 20),
        ])
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else { return }
        
        if label != selectedLabel {
            UIView.animate(withDuration: 0.2) {
                label.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            } completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    label.transform = .identity
                }
            }
            
            // Set underline for tapped label
            let attributedString = NSMutableAttributedString(string: label.text!)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
            label.attributedText = attributedString
            
            if let previousLabel = selectedLabel {
                let previousAttributedString = NSMutableAttributedString(string: previousLabel.text ?? "")
                previousAttributedString.removeAttribute(NSAttributedString.Key.underlineStyle, range: NSRange(location: 0, length: previousAttributedString.length))
                previousLabel.attributedText = previousAttributedString
            }
            
            selectedLabel = label
            switch label.text {
            case "CAST":
                currentData = casts
            case "GENRES":
                currentData = genres
            default:
                currentData = casts
            }
            collectionView.reloadData()
        }
    }

    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier, for: indexPath) as! TagCell
        cell.label.text = currentData[indexPath.item]
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = currentData[indexPath.item]
        let width = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)]).width + 20
        return CGSize(width: width, height: 30)
    }
}

class TagCell: UICollectionViewCell {
    static let identifier = "TagCell"
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = .darkGray
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
