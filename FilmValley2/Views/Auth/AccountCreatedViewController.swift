//
//  AccountCreatedViewController.swift
//  FilmValley2
//
//  Created by Trịnh Kiết Tường on 24/04/2024.
//

import UIKit

class AccountCreatedViewController: UIViewController {
    //MARK: -UI
    private var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Account Created!"
        label.textColor = UIColor(red: 0.098, green: 0.471, blue: 0.024, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    private var goToLoginBtn: UIButton = {
        let goToLoginBtn = UIButton()
        goToLoginBtn.translatesAutoresizingMaskIntoConstraints = false
        goToLoginBtn.backgroundColor = .blue
        goToLoginBtn.setTitle("Back to login", for: .normal)
        goToLoginBtn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        goToLoginBtn.layer.cornerRadius = 10
        goToLoginBtn.backgroundColor = UIColor(red: 0.098, green: 0.471, blue: 0.024, alpha: 1)
        return goToLoginBtn
    }()    
    
    //MARK: -LyfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUp()
        view.backgroundColor = .systemBackground
    }
    
    //MARK: -SetUp
    func SetUp(){
        view.addSubview(image)
        view.addSubview(label)
        view.addSubview(goToLoginBtn)
        image.image = UIImage(named: "AccountCreated")
        goToLoginBtn.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 100),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 50),
            image.heightAnchor.constraint(equalToConstant: 150),
            
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 23),
            label.heightAnchor.constraint(equalToConstant: 25),
            
            goToLoginBtn.topAnchor.constraint(equalTo: label.bottomAnchor,constant: 10),
            goToLoginBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 44),
            goToLoginBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44)
        ])
        
        
    }
    
    //MARK: -Actions
    @objc func didTapButton(){
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
        vc.navigationItem.setHidesBackButton(true, animated: false)
    }
}
