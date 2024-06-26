//
//  AddUserInfoViewController.swift
//  FilmValley2
//
//  Created by Trịnh Kiết Tường on 27/04/2024.
//

import UIKit
import FirebaseAuth
class AddUserInfoViewController: UIViewController {
    
    let genders = ["Male", "Female", "Other"]
    private let registerVM = RegisterAccountViewModel()
    private var email:String
    private var password:String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -UI
    private var usernameInput: UITextField = {
        let usernameInput = UITextField()
        usernameInput.translatesAutoresizingMaskIntoConstraints = false
        usernameInput.layer.borderWidth = 1
        usernameInput.placeholder = " Enter your username"
        usernameInput.autocapitalizationType = .none
        usernameInput.layer.borderColor = UIColor.systemGray2.cgColor
        usernameInput.layer.cornerRadius = 10
        usernameInput.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 48))
        usernameInput.leftViewMode = .always
        return usernameInput
    }()
    
    private var birthdayInput: UIDatePicker = {
        let ageInput = UIDatePicker()
        ageInput.translatesAutoresizingMaskIntoConstraints = false
        ageInput.datePickerMode = .date
        ageInput.maximumDate = Date()
        return ageInput
    }()
    
    private var birthdayLbl: UILabel = {
        let ageLbl = UILabel()
        ageLbl.text = "Birthday:"
        ageLbl.textColor = UIColor.systemGray
        ageLbl.translatesAutoresizingMaskIntoConstraints = false
        return ageLbl
    }()
    
    private var genderLbl: UILabel = {
        let ageLbl = UILabel()
        ageLbl.text = "Gender:"
        ageLbl.textColor = UIColor.systemGray
        ageLbl.translatesAutoresizingMaskIntoConstraints = false
        return ageLbl
    }()
    
    private var genderPicker: UIPickerView = {
        let genderP = UIPickerView()
        genderP.translatesAutoresizingMaskIntoConstraints = false
        genderP.isUserInteractionEnabled = true
        return genderP
    }()
    
    private var SignUpBtn: UIButton = {
        let SignUpBtn = UIButton()
        SignUpBtn.translatesAutoresizingMaskIntoConstraints = false
        SignUpBtn.backgroundColor = .blue
        SignUpBtn.setTitle("Create account", for: .normal)
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
        SetUp()
        print(email)
        print(password)
    }
    
    //MARK: -SetUp
    private func SetUp(){
        view.addSubview(usernameInput)
        view.addSubview(birthdayLbl)
        view.addSubview(birthdayInput)
        view.addSubview(genderLbl)
        view.addSubview(genderPicker)
        view.addSubview(SignUpBtn)
        
        genderPicker.delegate = self
        genderPicker.dataSource = self
        
        SignUpBtn.addTarget(self, action: #selector(SignUpBtnTapped), for: .touchUpInside)
        birthdayInput.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        
        NSLayoutConstraint.activate([
            usernameInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            usernameInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            usernameInput.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            usernameInput.heightAnchor.constraint(equalToConstant: 48),
            
            birthdayLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            birthdayLbl.topAnchor.constraint(equalTo: usernameInput.bottomAnchor, constant: 30),
            birthdayLbl.heightAnchor.constraint(equalToConstant: 25),
            
            birthdayInput.leadingAnchor.constraint(equalTo: birthdayLbl.trailingAnchor,constant: 10),
            birthdayInput.centerYAnchor.constraint(equalTo: birthdayLbl.centerYAnchor),
            
            genderLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            genderLbl.topAnchor.constraint(equalTo: birthdayInput.bottomAnchor, constant:39),
            
            genderPicker.leadingAnchor.constraint(equalTo: genderLbl.trailingAnchor, constant: 15),
            genderPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -155),
            genderPicker.topAnchor.constraint(equalTo: birthdayInput.bottomAnchor),
            genderPicker.heightAnchor.constraint(equalToConstant: 100),
            
            SignUpBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 33),
            SignUpBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -33),
            SignUpBtn.topAnchor.constraint(equalTo: genderPicker.bottomAnchor, constant: 20),
            SignUpBtn.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    
    //MARK: -Actions
    @objc func SignUpBtnTapped() {
        UIView.animate(withDuration: 0.2) {
            self.SignUpBtn.backgroundColor = self.SignUpBtn.backgroundColor?.withAlphaComponent(0.7)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.SignUpBtn.backgroundColor = self.SignUpBtn.backgroundColor?.withAlphaComponent(1)
            }
        }
        guard let username = usernameInput.text, !username.isEmpty, username.count > 6, username.count < 20 else {
            let alert = UIAlertController(title: "Invalid username", message: "Username cannot be empty and must be longer than 6 and smaller than 20 characters", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            usernameInput.text = ""
            return
        }
        registerVM.checkUsernameExists(username: username) { (exists, error) in
            if let error = error {
                print("Error checking username:", error.localizedDescription)
                return
            }
            if exists {
                let alert = UIAlertController(title: "Username exists", message: "Please choose a different username.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            else{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let birthday = dateFormatter.string(from: self.birthdayInput.date)
                let genderSelected = self.genderPicker.selectedRow(inComponent: 0)
                let gender = self.genders[genderSelected]
                print(self.email,self.password,username,birthday,gender)
                
                self.registerVM.createUser(email: self.email, password: self.password, username: username, birthday: birthday, gender: gender) { success, error in
                    if let error = error {
                        print("Error creating user:", error.localizedDescription)
                    } else if success {
                        if let uid = Auth.auth().currentUser?.uid{
                            print(uid)
                            self.registerVM.createUserInFavouriteList(userId: uid) { error in
                                if let _ = error{
                                    print("Can't create favourite")
                                }else{
                                    print("Favourite created")
                                }
                            }
                        }
                        
                        DispatchQueue.main.async {
                            let vc = LoginViewController()
                            vc.navigationItem.setHidesBackButton(true, animated: false)
                            self.navigationController?.pushViewController(vc, animated: true)
                            let alert = UIAlertController(title: "", message: "User create successfully!", preferredStyle: .alert)
                            alert.setMessage(font: UIFont.systemFont(ofSize: 14), color: .systemGreen)
                            self.present(alert, animated: true, completion: nil)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                alert.dismiss(animated: true)
                            }
                        }
                    } else {
                        print("User creation failed.")
                    }
                }
            }
        }
        
        
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = dateFormatter.string(from: sender.date)
        print("Selected date: \(selectedDate)")
    }
    
}

extension AddUserInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = genders[row]
        return label
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let _ = genders[row]
    }
    
    
}



