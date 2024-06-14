//
//  SettingViewController.swift
//  FilmValley2
//
//  Created by Trịnh Kiết Tường on 26/04/2024.
//

import UIKit
import FirebaseAuth
import Firebase

class AccountInfoViewController: UIViewController {
    
    let viewModel = AccountInfoViewModel()
    
    // MARK: - UI Components
    private let titleLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Account information"
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private var avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    private var usernameLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private var divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        return view
    }()
    
    private var emailLbl: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "envelope.fill")
        imageView.tintColor = .systemGray
        return imageView
    }()
    
    private var emailContent: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    private var genderLbl: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .systemGray
        return imageView
    }()
    
    private var genderContent: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    private var birthLbl: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "birthday.cake.fill")
        imageView.tintColor = .systemGray
        return imageView
    }()
    
    private var birthContent: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    private var dateJoinLbl: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "calendar.circle")
        imageView.tintColor = .systemGray
        return imageView
    }()
    
    private var dateJoinContent: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    private var editAvatarBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "pencil.line")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.layer.borderWidth = 1
        button.contentMode = .scaleAspectFill
        button.backgroundColor = .systemGray6
        button.layer.masksToBounds = true
        return button
    }()
    
    private var divider2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        return view
    }()
    
    private var favBtn: UIButton = {
        let favBtn = UIButton()
        favBtn.translatesAutoresizingMaskIntoConstraints = false
        favBtn.configuration = .tinted()
        favBtn.configuration?.baseForegroundColor = .systemPink
        
        let title = "Favourite list"
        let attribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15, weight: .semibold),
            .foregroundColor: UIColor.systemPink
        ]
        
        let attributeTitle = NSAttributedString(string: title, attributes: attribute)
        
        
        favBtn.configuration?.attributedTitle = AttributedString(attributeTitle)
        favBtn.configuration?.subtitle = "Things that you already like"
        favBtn.configuration?.image = UIImage(systemName: "heart.fill")
        favBtn.configuration?.imagePadding = 6
        favBtn.configuration?.imagePlacement = .leading
        favBtn.configuration?.baseBackgroundColor = .systemGray4
        return favBtn
    }()
    
    private var favouriteView: UIView = {
        let favView = UIView()
        favView.translatesAutoresizingMaskIntoConstraints = false
        favView.backgroundColor = .systemBackground
        favView.layer.borderWidth = 1
        favView.layer.borderColor = UIColor.systemGray.cgColor
        favView.layer.cornerRadius = 10
        return favView
    }()
    
    private var editProfileBtn: UIButton = {
        let editProfileBtn = UIButton()
        editProfileBtn.translatesAutoresizingMaskIntoConstraints = false
        editProfileBtn.setTitle("edit profile", for: .normal)
        editProfileBtn.setTitleColor(.systemBlue, for: .normal)
        editProfileBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return editProfileBtn
    }()
    
    private var historyButton: UIButton = {
        let historyButton = UIButton()
        historyButton.translatesAutoresizingMaskIntoConstraints = false
        historyButton.configuration = .tinted()
        historyButton.configuration?.baseForegroundColor = UIColor(red: 0.224, green: 0.612, blue: 0.043, alpha: 1)
        
        let title = "Watch List"
        let attribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15, weight: .semibold),
            .foregroundColor: UIColor(red: 0.224, green: 0.612, blue: 0.043, alpha: 1)
        ]
        
        let attributeTitle = NSAttributedString(string: title, attributes: attribute)
        
        historyButton.configuration?.attributedTitle = AttributedString(attributeTitle)
        historyButton.configuration?.subtitle = "Your Viewing History           "
        historyButton.configuration?.image = UIImage(systemName: "film.stack.fill")
        historyButton.configuration?.imagePadding = 6
        historyButton.configuration?.imagePlacement = .leading
        historyButton.configuration?.baseBackgroundColor = .systemGray4
        return historyButton
    }()
    
    
    
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Account"
        setupViews()
        fetchUserInfo()
        
        let loadingAlert = UIAlertController(title: "", message: "Loading...", preferredStyle: .alert)
        self.present(loadingAlert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            loadingAlert.dismiss(animated: true)
        }
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        view.addSubview(avatar)
        view.addSubview(usernameLbl)
        view.addSubview(divider)
        view.addSubview(titleLbl)
        view.addSubview(emailLbl)
        view.addSubview(emailContent)
        view.addSubview(genderLbl)
        view.addSubview(genderContent)
        view.addSubview(birthLbl)
        view.addSubview(birthContent)
        view.addSubview(dateJoinLbl)
        view.addSubview(dateJoinContent)
        view.addSubview(editAvatarBtn)
        view.addSubview(divider2)
        view.addSubview(favBtn)
        view.addSubview(editProfileBtn)
        view.addSubview(historyButton)
        
        avatar.image = UIImage(named: "avatar")
        
        avatar.layer.cornerRadius = avatar.frame.height / 2
        
        favBtn.addTarget(self, action: #selector(didTapFavouriteBtn), for: .touchUpInside)
        
        editProfileBtn.addTarget(self, action: #selector(didTapEditProfileBtn), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.forward"), style: .plain, target: self, action: #selector(menuButtonTapped))
        navigationItem.rightBarButtonItem?.customView?.semanticContentAttribute = .forceRightToLeft

        editAvatarBtn.addTarget(self, action: #selector(didTappedAvatarEditBtn), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatar.heightAnchor.constraint(equalToConstant: 150),
            avatar.widthAnchor.constraint(equalToConstant: 150),
            
            usernameLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameLbl.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 20),
            
            editProfileBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editProfileBtn.topAnchor.constraint(equalTo: usernameLbl.bottomAnchor, constant: 2),
            editProfileBtn.heightAnchor.constraint(equalToConstant: 14 ),
            
            divider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            divider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            divider.topAnchor.constraint(equalTo: editProfileBtn.bottomAnchor, constant: 10),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            titleLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17),
            titleLbl.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 20),
            titleLbl.heightAnchor.constraint(equalToConstant: 20),
            
            emailLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            emailLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 20),
            emailLbl.heightAnchor.constraint(equalToConstant: 24),
            emailLbl.widthAnchor.constraint(equalToConstant: 24),
            
            emailContent.leadingAnchor.constraint(equalTo: emailLbl.trailingAnchor, constant: 10),
            emailContent.centerYAnchor.constraint(equalTo: emailLbl.centerYAnchor),
            emailContent.heightAnchor.constraint(equalToConstant: 20),
            
            genderLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            genderLbl.topAnchor.constraint(equalTo: emailLbl.bottomAnchor, constant: 17),
            genderLbl.heightAnchor.constraint(equalToConstant: 24),
            genderLbl.widthAnchor.constraint(equalToConstant: 24),
            
            genderContent.leadingAnchor.constraint(equalTo: genderLbl.trailingAnchor, constant: 10),
            genderContent.centerYAnchor.constraint(equalTo: genderLbl.centerYAnchor),
            genderContent.heightAnchor.constraint(equalToConstant: 20),
            
            birthLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            birthLbl.topAnchor.constraint(equalTo: genderLbl.bottomAnchor, constant: 17),
            birthLbl.heightAnchor.constraint(equalToConstant: 24),
            birthLbl.widthAnchor.constraint(equalToConstant: 24),
            
            birthContent.leadingAnchor.constraint(equalTo: birthLbl.trailingAnchor, constant: 11),
            birthContent.centerYAnchor.constraint(equalTo: birthLbl.centerYAnchor, constant: 3),
            birthContent.heightAnchor.constraint(equalToConstant: 20),
            
            dateJoinLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            dateJoinLbl.topAnchor.constraint(equalTo: birthLbl.bottomAnchor, constant: 20),
            dateJoinLbl.heightAnchor.constraint(equalToConstant: 24),
            dateJoinLbl.widthAnchor.constraint(equalToConstant: 24),
            
            dateJoinContent.leadingAnchor.constraint(equalTo: dateJoinLbl.trailingAnchor, constant: 11),
            dateJoinContent.centerYAnchor.constraint(equalTo: dateJoinLbl.centerYAnchor),
            dateJoinContent.heightAnchor.constraint(equalToConstant: 20),
            
            editAvatarBtn.widthAnchor.constraint(equalToConstant: 38),
            editAvatarBtn.heightAnchor.constraint(equalToConstant: 38),
            editAvatarBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 40),
            editAvatarBtn.centerYAnchor.constraint(equalTo: usernameLbl.centerYAnchor, constant: -40),
            
            divider2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            divider2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            divider2.topAnchor.constraint(equalTo: dateJoinContent.bottomAnchor, constant: 20),
            divider2.heightAnchor.constraint(equalToConstant: 1),
            
            favBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            favBtn.topAnchor.constraint(equalTo: divider2.bottomAnchor, constant: 10),
            favBtn.widthAnchor.constraint(equalToConstant: 230),
            favBtn.heightAnchor.constraint(equalToConstant: 44),
            
            historyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 15),
            historyButton.topAnchor.constraint(equalTo: favBtn.bottomAnchor, constant: 15),
            historyButton.widthAnchor.constraint(equalToConstant: 230),
            historyButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatar.layer.cornerRadius = avatar.frame.height / 2
        editAvatarBtn.layer.cornerRadius = editAvatarBtn.frame.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favouriteView.removeFromSuperview()
        if let vc = children.last as? FavouriteListViewController {
            vc.willMove(toParent: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }
        
        UIView.animate(withDuration: 0.3) {
            self.avatar.alpha = 1
            self.usernameLbl.alpha = 1
            self.divider.alpha = 1
            self.titleLbl.alpha = 1
            self.emailLbl.alpha = 1
            self.emailContent.alpha = 1
            self.genderLbl.alpha = 1
            self.genderContent.alpha = 1
            self.birthLbl.alpha = 1
            self.birthContent.alpha = 1
            self.editAvatarBtn.alpha = 1
        }
    }
    
    //MARK: -Actions
    @objc func menuButtonTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "Log out", style: .destructive) { _ in
            do {
                try Auth.auth().signOut()
                let loginVC = LoginViewController()
                let navController = UINavigationController(rootViewController: loginVC)
                navController.modalPresentationStyle = .fullScreen
                
                let logoutSuccessAlert = UIAlertController(title: "", message: "Log out successfully", preferredStyle: .alert)
                self.present(logoutSuccessAlert, animated: true, completion: nil)
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    if let window = windowScene.windows.first {
                        window.rootViewController = navController
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    logoutSuccessAlert.dismiss(animated: true)
                }
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }
        alert.addAction(logoutAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func updateUI(with accountInfo: AccountInfo) {
        usernameLbl.text = accountInfo.username
        emailContent.text = accountInfo.email
        genderContent.text = accountInfo.gender
        birthContent.text = accountInfo.birthday
        dateJoinContent.text = accountInfo.dateJoined
        print(accountInfo.avatarURL)
    }
    
    func fetchUserInfo() {
        viewModel.fetchUserInfo { [weak self] accountInfo in
            guard let accountInfo = accountInfo else {
                return
            }
            DispatchQueue.main.async {
                self?.updateUI(with: accountInfo)
                self?.loadAvatar(from: accountInfo.avatarURL)
            }
        }
    }
    
    func loadAvatar(from urlString: String) {
        viewModel.loadImage(from: urlString) { [weak self] image in
            guard let image = image else {
                return
            }
            self?.avatar.image = image
        }
    }
    
    @objc func didTappedAvatarEditBtn() {
        UIView.animate(withDuration: 0.2) {
            self.editAvatarBtn.backgroundColor = self.editAvatarBtn.backgroundColor?.withAlphaComponent(0.7)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.editAvatarBtn.backgroundColor = self.editAvatarBtn.backgroundColor?.withAlphaComponent(1)
            }
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func didTapFavouriteBtn(){
        UIView.animate(withDuration: 0.3) {
            self.avatar.alpha = 0.5
            self.usernameLbl.alpha = 0.5
            self.divider.alpha = 0.5
            self.titleLbl.alpha = 0.5
            self.emailLbl.alpha = 0.5
            self.emailContent.alpha = 0.5
            self.genderLbl.alpha = 0.5
            self.genderContent.alpha = 0.5
            self.birthLbl.alpha = 0.5
            self.birthContent.alpha = 0.5
            self.editAvatarBtn.alpha = 0.5
        }
        favouriteView.alpha = 0
        
        favouriteView.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        
        view.addSubview(favouriteView)
        
        NSLayoutConstraint.activate([
            favouriteView.topAnchor.constraint(equalTo: view.topAnchor,constant: 500),
            favouriteView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            favouriteView.widthAnchor.constraint(equalToConstant: 380),
            favouriteView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        let vc = FavouriteListViewController()
        
        addChild(vc)
        
        favouriteView.addSubview(vc.view)
        
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            vc.view.topAnchor.constraint(equalTo: favouriteView.topAnchor, constant: 40),
            vc.view.bottomAnchor.constraint(equalTo: favouriteView.bottomAnchor),
            vc.view.leadingAnchor.constraint(equalTo: favouriteView.leadingAnchor, constant: 10),
            vc.view.trailingAnchor.constraint(equalTo: favouriteView.trailingAnchor, constant: -10),
        ])
        
        vc.didMove(toParent: self)
        
        let titleFav = UILabel()
        titleFav.text = "Favorite List"
        titleFav.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        titleFav.translatesAutoresizingMaskIntoConstraints = false
        
        let closeButton = UIButton()
        let closeBtnImg = UIImage(systemName: "x.circle.fill")
        closeButton.tintColor = UIColor.systemGray2
        closeButton.setImage(closeBtnImg, for: .normal)
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        
        favouriteView.addSubview(closeButton)
        favouriteView.addSubview(titleFav)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: favouriteView.topAnchor, constant: 0),
            closeButton.trailingAnchor.constraint(equalTo: favouriteView.trailingAnchor,constant: 0),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            
            titleFav.leadingAnchor.constraint(equalTo: favouriteView.leadingAnchor, constant: 10),
            titleFav.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor)
        ])
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {                self.favouriteView.alpha = 1
            self.favouriteView.transform = .identity
        }, completion: nil)
        
    }
    
    @objc func didTapCloseButton() {
        UIView.animate(withDuration: 0.3) {
            self.avatar.alpha = 1
            self.usernameLbl.alpha = 1
            self.divider.alpha = 1
            self.titleLbl.alpha = 1
            self.emailLbl.alpha = 1
            self.emailContent.alpha = 1
            self.genderLbl.alpha = 1
            self.genderContent.alpha = 1
            self.birthLbl.alpha = 1
            self.birthContent.alpha = 1
            self.editAvatarBtn.alpha = 1
        }
        
        favouriteView.removeFromSuperview()
        if let vc = children.last as? FavouriteListViewController {
            vc.willMove(toParent: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }
    }
    
    @objc private func didTapEditProfileBtn() {  
        viewModel.fetchUserInfo { userInfo in
            let username = userInfo?.username
            let gender = userInfo?.gender
            let birthday = userInfo?.birthday
            
            let sheetViewController = EditProfileViewController(username: username ?? "", gender: gender ?? "", birthday: birthday ?? "")
            if let sheet = sheetViewController.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            }
            self.present(sheetViewController, animated: true, completion: nil)
        }
    }
}

extension AccountInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            viewModel.uploadImageToFirebase(selectedImage) { imageURL in
                guard let imageURL = imageURL else {
                    return
                }
                print("Image uploaded successfully. URL:", imageURL)
                
                let newAvatar = "gs://film-valley.appspot.com/\(imageURL)"
                self.viewModel.updateAvatar(url: newAvatar)
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
        let updatedAlert = UIAlertController(title: "", message: "Update Successfully!", preferredStyle: .alert)
        self.present(updatedAlert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            updatedAlert.dismiss(animated: true)
        }
    }
}

