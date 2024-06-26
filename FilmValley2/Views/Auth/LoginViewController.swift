//
//  LoginViewController.swift
//  FilmValley2
//
//  Created by Trịnh Kiết Tường on 23/04/2024.
//

import UIKit

class LoginViewController: UIViewController {
    
    private var LoginVM = LoginViewModel()
    
    //MARK: -UI
    private var image:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var logoTitle:UITextView = {
        let title = UITextView()
        title.isEditable = false
        title.isSelectable = false
        title.font = UIFont(name: "Impact", size: 35)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Film Valley"
        return title
    }()
    
    private var emailInput: UITextField = {
        let emailInput = UITextField()
        emailInput.translatesAutoresizingMaskIntoConstraints = false
        emailInput.layer.borderWidth = 1
        emailInput.layer.borderColor = UIColor.systemGray3.cgColor
        emailInput.placeholder = " Enter your email..."
        emailInput.autocapitalizationType = .none
        emailInput.layer.cornerRadius = 10
        emailInput.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 48))
        emailInput.leftViewMode = .always
        return emailInput
    }()
    
    private var passwordInput: UITextField = {
        let passInput = UITextField()
        passInput.translatesAutoresizingMaskIntoConstraints = false
        passInput.layer.borderWidth = 1
        passInput.autocapitalizationType = .none
        passInput.layer.borderColor = UIColor.systemGray3.cgColor
        passInput.placeholder = " Enter your password..."
        passInput.layer.cornerRadius = 10
        passInput.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 48))
        passInput.leftViewMode = .always
        passInput.isSecureTextEntry = true
        return passInput
    }()
    
    private var loginBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.translatesAutoresizingMaskIntoConstraints = false
        loginBtn.backgroundColor = .blue
        loginBtn.setTitle("Login", for: .normal)
        loginBtn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        loginBtn.layer.cornerRadius = 10
        loginBtn.backgroundColor = .systemCyan
        return loginBtn
    }()
    
    private var registerTitle: UILabel = {
        let registerTitle = UILabel()
        registerTitle.translatesAutoresizingMaskIntoConstraints = false
        registerTitle.text = "Don't have an account yet?"
        registerTitle.textColor = .systemGray2
        return registerTitle
    }()
    
    private var registerBtn: UIButton = {
        let registerBtn = UIButton()
        registerBtn.translatesAutoresizingMaskIntoConstraints = false
        registerBtn.setTitle("Register", for: .normal)
        registerBtn.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        registerBtn.setTitleColor(.systemGreen, for: .normal)
        registerBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return registerBtn
    }()
    
    
    
    //MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.setHidesBackButton(true, animated: false)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
             view.addGestureRecognizer(tapGesture)
        SetUp()
    }
    
    //MARK: -SetUp
    private func SetUp(){
        view.addSubview(image)
        view.addSubview(logoTitle)
        view.addSubview(emailInput)
        view.addSubview(passwordInput)
        view.addSubview(loginBtn)
        view.addSubview(registerTitle)
        view.addSubview(registerBtn)
        
        registerBtn.addTarget(self, action: #selector(didTapRegisterBtn), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(didTapLoginBtn), for: .touchDown)
        
        image.image = UIImage(named: "AppIcon")
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            image.widthAnchor.constraint(equalToConstant: 120),
            image.heightAnchor.constraint(equalToConstant: 120),
            
            logoTitle.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 5),
            logoTitle.centerYAnchor.constraint(equalTo: image.centerYAnchor),
            logoTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            logoTitle.heightAnchor.constraint(equalToConstant: 55),
            
            emailInput.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -33),
            emailInput.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 33),
            emailInput.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 40),
            emailInput.heightAnchor.constraint(equalToConstant: 48),
            
            passwordInput.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -33),
            passwordInput.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 33),
            passwordInput.topAnchor.constraint(equalTo: emailInput.bottomAnchor, constant: 25),
            passwordInput.heightAnchor.constraint(equalToConstant: 48),
            
            loginBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 37),
            loginBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -37),
            loginBtn.topAnchor.constraint(equalTo: passwordInput.bottomAnchor, constant: 23),
            loginBtn.heightAnchor.constraint(equalToConstant: 44),
            
            registerTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: -37),
            registerTitle.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            registerTitle.heightAnchor.constraint(equalToConstant: 20),
            
            registerBtn.leadingAnchor.constraint(equalTo: registerTitle.trailingAnchor, constant: -25),
            registerBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -28),
            registerBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            registerBtn.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    //MARK: - Actions
    
    @objc func didTapRegisterBtn(){
        let registerVC = RegisterAccountViewController()
        navigationController?.pushViewController(registerVC, animated: true)
        registerVC.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func didTapLoginBtn() {
        //Animation
        UIView.animate(withDuration: 0.2) {
            self.loginBtn.backgroundColor = self.loginBtn.backgroundColor?.withAlphaComponent(0.7)
        } completion: {_ in
            UIView.animate(withDuration: 0.2) {
                self.loginBtn.backgroundColor = self.loginBtn.backgroundColor?.withAlphaComponent(1)
            }
        }
        
        //Guard
        guard let email = emailInput.text, !email.isEmpty, isValidEmail(email) else {
            let alert = UIAlertController(title: "Something wrong with email", message: "Please check your email again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            emailInput.text = ""
            return
        }
        
        guard let password = passwordInput.text, !password.isEmpty, password.count > 8 else {
            let alert = UIAlertController(title: "Something wrong with password", message: "Please check your password again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            passwordInput.text = ""
            return
        }
        
        //SignIn
        LoginVM.signIn(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    let vc = TabbarViewController(currentUser: user)
                    vc.currentUser = user
                    self.navigationController?.pushViewController(vc, animated: true)
                    self.navigationController?.navigationBar.isHidden = true
                }
            case .failure:
                self?.showAlert(title: "Login failed", message: "The email address or password is incorrect")
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
        
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    
    
    
    
    
    // MARK: - Helper Functions
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

