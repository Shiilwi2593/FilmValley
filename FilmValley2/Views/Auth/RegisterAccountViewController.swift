//
//  RegisterAccountViewController.swift
//  FilmValley2
//
//  Created by Trịnh Kiết Tường on 24/04/2024.
//

import UIKit

class RegisterAccountViewController: UIViewController {
    
    private var registerVM = RegisterAccountViewModel()
    
    //MARK: -UI
    private var emailInput: UITextField = {
        let emailInput = UITextField()
        emailInput.translatesAutoresizingMaskIntoConstraints = false
        emailInput.layer.borderWidth = 1
        emailInput.placeholder = " Enter your email"
        emailInput.autocapitalizationType = .none
        emailInput.layer.borderColor = UIColor.systemGray2.cgColor
        emailInput.layer.cornerRadius = 10
        emailInput.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 48))
        emailInput.leftViewMode = .always
        return emailInput
    }()
    
    private var passwordInput: UITextField = {
        let passwordInput = UITextField()
        passwordInput.translatesAutoresizingMaskIntoConstraints = false
        passwordInput.layer.borderWidth = 1
        passwordInput.placeholder = " Enter your password"
        passwordInput.autocapitalizationType = .none
        passwordInput.layer.borderColor = UIColor.systemGray2.cgColor
        passwordInput.layer.cornerRadius = 10
        passwordInput.isSecureTextEntry = true
        passwordInput.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 48))
        passwordInput.leftViewMode = .always
        return passwordInput
    }()
    
    private var rePasswordInput: UITextField = {
        let rePasswordInput = UITextField()
        rePasswordInput.translatesAutoresizingMaskIntoConstraints = false
        rePasswordInput.layer.borderWidth = 1
        rePasswordInput.placeholder = " Confirm password"
        rePasswordInput.autocapitalizationType = .none
        rePasswordInput.layer.borderColor = UIColor.systemGray2.cgColor
        rePasswordInput.layer.cornerRadius = 10
        rePasswordInput.isSecureTextEntry = true
        rePasswordInput.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 48))
        rePasswordInput.leftViewMode = .always
        return rePasswordInput
    }()
    
    private var SignUpBtn: UIButton = {
        let SignUpBtn = UIButton()
        SignUpBtn.translatesAutoresizingMaskIntoConstraints = false
        SignUpBtn.backgroundColor = .blue
        SignUpBtn.setTitle("next", for: .normal)
        SignUpBtn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        SignUpBtn.layer.cornerRadius = 10
        SignUpBtn.backgroundColor = UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark{
                return .white
            }
            else {
                return .black
            }
        }
        SignUpBtn.setTitleColor(UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return .black
            } else {
                return .white
            }
        }, for: .normal)
        return SignUpBtn
    }()
    
    
    //MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Sign Up"
        SetUp()
    }
    
    
    //MARK: -SetUp
    private func SetUp(){
        view.addSubview(emailInput)
        view.addSubview(SignUpBtn)
        view.addSubview(passwordInput)
        view.addSubview(rePasswordInput)
        
        SignUpBtn.addTarget(self, action: #selector(didTabButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            emailInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emailInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            emailInput.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            emailInput.heightAnchor.constraint(equalToConstant: 48),
            
            passwordInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passwordInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            passwordInput.topAnchor.constraint(equalTo: emailInput.bottomAnchor, constant: 15),
            passwordInput.heightAnchor.constraint(equalToConstant: 48),
            
            rePasswordInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            rePasswordInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            rePasswordInput.topAnchor.constraint(equalTo: passwordInput.bottomAnchor, constant: 15),
            rePasswordInput.heightAnchor.constraint(equalToConstant: 48),
            
            SignUpBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            SignUpBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            SignUpBtn.topAnchor.constraint(equalTo: rePasswordInput.bottomAnchor, constant: 15),
            SignUpBtn.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    // MARK: - Actions
    
    @objc func didTabButton(){
        //Animation
        UIView.animate(withDuration: 0.2) {
            self.SignUpBtn.backgroundColor = self.SignUpBtn.backgroundColor?.withAlphaComponent(0.7)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.SignUpBtn.backgroundColor = self.SignUpBtn.backgroundColor?.withAlphaComponent(1)
            }
        }
        
        //Guard
        guard let email = emailInput.text, !email.isEmpty, isValidEmail(email) else {
            let alert = UIAlertController(title: "Invalid Email", message: "Check your email again!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            emailInput.text = ""
            return
        }
        
        guard let password = passwordInput.text, !password.isEmpty, password.count > 8 else {
            let alert = UIAlertController(title: "Password is not secure", message: "Password length must be more than 8 characters", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            passwordInput.text = ""
            rePasswordInput.text = ""
            return
        }
        
        guard let repassword = rePasswordInput.text, !repassword.isEmpty, repassword == password else{
            let alert = UIAlertController(title: "Passwords not matched", message: "password and confirm password do not match", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            rePasswordInput.text = ""
            return
        }
        
        registerVM.registerUser(withEmail: email, password: password) { success in
            if success {
                let vc = AddUserInfoViewController(email: email, password: password)
                vc.navigationItem.setHidesBackButton(false, animated: false)
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let alert = UIAlertController(title: "Email Already Registered", message: "This email has already been registered.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

}
