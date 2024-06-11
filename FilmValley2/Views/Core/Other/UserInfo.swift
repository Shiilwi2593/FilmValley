import UIKit
import FirebaseStorage

class UserInfo: UIView {

    private var userInfo: [String: Any] = [:]

    private var usernameLbl: UILabel = {
        let username = UILabel()
        username.font = UIFont.systemFont(ofSize: 18, weight: .bold)
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
        genderLbl.font = UIFont.systemFont(ofSize: 16)
        genderLbl.textAlignment = .center
        return genderLbl
    }()

    private var birthdayLbl: UILabel = {
        let birthdayLbl = UILabel()
        birthdayLbl.font = UIFont.systemFont(ofSize: 16)
        birthdayLbl.textAlignment = .center
        return birthdayLbl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor

        self.addSubview(usernameLbl)
        self.addSubview(avatar)
        self.addSubview(genderLbl)
        self.addSubview(birthdayLbl)

        usernameLbl.translatesAutoresizingMaskIntoConstraints = false
        avatar.translatesAutoresizingMaskIntoConstraints = false
        genderLbl.translatesAutoresizingMaskIntoConstraints = false
        birthdayLbl.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            avatar.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 120),
            avatar.heightAnchor.constraint(equalToConstant: 120),

            usernameLbl.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 16),
            usernameLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            usernameLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),

            birthdayLbl.topAnchor.constraint(equalTo: usernameLbl.bottomAnchor, constant: 3),
            birthdayLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            birthdayLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),

            genderLbl.topAnchor.constraint(equalTo: birthdayLbl.bottomAnchor, constant: 3),
            genderLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            genderLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            genderLbl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])
    }

    func configure(with userInfo: [String: Any]) {
        self.userInfo = userInfo

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
                    print("Invalid image data or no image received")
                    completion(nil)
                }
            }
        }
    }
}
