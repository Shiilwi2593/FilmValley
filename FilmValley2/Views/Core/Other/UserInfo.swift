import UIKit
import FirebaseStorage

class UserInfo: UIView {

    private var userInfo: [String: Any] = [:]

    private var usernameLbl: UILabel = {
        let username = UILabel()
        username.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        username.textAlignment = .center
        return username
    }()

    private var avatar: UIImageView = {
        let avatar = UIImageView()
        avatar.contentMode = .scaleAspectFill
        avatar.layer.cornerRadius = 30
        avatar.layer.masksToBounds = true
        return avatar
    }()

    private var genderLbl: UILabel = {
        let genderLbl = UILabel()
        genderLbl.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        genderLbl.textAlignment = .center
        return genderLbl
    }()

    private var birthdayLbl: UILabel = {
        let birthdayLbl = UILabel()
        birthdayLbl.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        birthdayLbl.textAlignment = .center
        return birthdayLbl
    }()
    
    private var commentLBl: UILabel = {
       let commentLbl = UILabel()
        commentLbl.translatesAutoresizingMaskIntoConstraints = false
        commentLbl.text = "Review:"
        commentLbl.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return commentLbl
    }()
    
    private var reviewText: UITextView = {
        let reviewTxt = UITextView()
        reviewTxt.translatesAutoresizingMaskIntoConstraints = false
        reviewTxt.textAlignment = .natural
        reviewTxt.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        reviewTxt.textColor = .systemGray
        reviewTxt.isEditable = false
        reviewTxt.isScrollEnabled = true
        reviewTxt.textContainerInset = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10) // Customize the
        return reviewTxt
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor

        self.addSubview(usernameLbl)
        self.addSubview(avatar)
        self.addSubview(genderLbl)
        self.addSubview(birthdayLbl)
        self.addSubview(commentLBl)
        self.addSubview(reviewText)

        usernameLbl.translatesAutoresizingMaskIntoConstraints = false
        avatar.translatesAutoresizingMaskIntoConstraints = false
        genderLbl.translatesAutoresizingMaskIntoConstraints = false
        birthdayLbl.translatesAutoresizingMaskIntoConstraints = false
        commentLBl.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            avatar.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 12),
            avatar.widthAnchor.constraint(equalToConstant: 100),
            avatar.heightAnchor.constraint(equalToConstant: 100),

            usernameLbl.topAnchor.constraint(equalTo: self.topAnchor, constant: 25),
            usernameLbl.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 9),

            birthdayLbl.topAnchor.constraint(equalTo: usernameLbl.bottomAnchor, constant: 4),
            birthdayLbl.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 12),

            genderLbl.topAnchor.constraint(equalTo: birthdayLbl.bottomAnchor, constant: 4),
            genderLbl.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 12),
            
            commentLBl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13),
            commentLBl.heightAnchor.constraint(equalToConstant: 10),
            commentLBl.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 14),
            
            reviewText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13),
            reviewText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -13),
            reviewText.topAnchor.constraint(equalTo: commentLBl.bottomAnchor, constant: 4),
            reviewText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }

    func configure(with userInfo: [String: Any], review: String) {
        self.userInfo = userInfo
        self.reviewText.text = review

        if let username = userInfo["username"] as? String {
            usernameLbl.text = "\(username)"
        }

        if let avatarURL = userInfo["avatar"] as? String {
            loadImage(from: avatarURL) { [weak self] image in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.avatar.image = image
                }
            }
        }

        if let birthday = userInfo["birthday"] as? String {
            birthdayLbl.text = "Birthday: \(birthday)"
        }

        if let gender = userInfo["gender"] as? String {
            genderLbl.text = "Gender: \(gender)"
        }
    }

    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        let storageRef = Storage.storage().reference(forURL: urlString)
        
        storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading image:", error.localizedDescription)
                completion(nil)
            } else {
                if let imageData = data, let image = UIImage(data: imageData) {
                    completion(image)
                } else {
                    print("Invalid image data or no image received!")
                    completion(nil)
                }
            }
        }
    }
    
    
}
