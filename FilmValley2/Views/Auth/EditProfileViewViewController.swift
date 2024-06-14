//
//  EditProfileViewViewController.swift
//  FilmValley2
//
//  Created by Trịnh Kiết Tường on 13/06/2024.
//

import UIKit

class EditProfileViewController: UIViewController {

    let viewmodel = AccountInfoViewModel()
    
    var username: String
    var gender: String
    var birthday: String
        
    init(username: String, gender: String, birthday: String) {
        self.username = username
        self.gender = gender
        self.birthday = birthday
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: -UI
    // UI Components
    private var headTitle: UILabel = {
        let headTitle = UILabel()
        headTitle.translatesAutoresizingMaskIntoConstraints = false
        headTitle.text = "Edit profile"
        headTitle.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return headTitle
    }()
    
    private var divider: UIView = {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .systemGray6
        return divider
    }()
    
    private var usernameLbl: UILabel = {
        let usernameLbl = UILabel()
        usernameLbl.translatesAutoresizingMaskIntoConstraints = false
        usernameLbl.text = "Username"
        usernameLbl.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return usernameLbl
    }()
    
    private var usernameField: UITextField = {
        let usernameField = UITextField()
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        usernameField.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        usernameField.autocapitalizationType = .none
        return usernameField
    }()
    
    private var divider2: UIView = {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .systemGray6
        return divider
    }()
    
    
    
    private var genderLbl: UILabel = {
        let genderLbl = UILabel()
        genderLbl.translatesAutoresizingMaskIntoConstraints = false
        genderLbl.text = "Gender"
        genderLbl.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return genderLbl
    }()
    
    private var genderSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Male", "Female", "Other"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private var divider3: UIView = {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .systemGray6
        return divider
    }()
    
    private var birthDayLbl: UILabel = {
        let birthDayLbl = UILabel()
        birthDayLbl.translatesAutoresizingMaskIntoConstraints = false
        birthDayLbl.text = "Birthday"
        birthDayLbl.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return birthDayLbl
    }()
    
    private var birthdayInput: UIDatePicker = {
        let ageInput = UIDatePicker()
        ageInput.translatesAutoresizingMaskIntoConstraints = false
        ageInput.datePickerMode = .date
        ageInput.maximumDate = Date()
        return ageInput
    }()
    
    private var confirmBtn: UIButton = {
        let confirmBtn = UIButton()
        confirmBtn.translatesAutoresizingMaskIntoConstraints = false
        var config = UIButton.Configuration.filled()
        config.title = "Save"
        config.macIdiomStyle = .bordered
        config.baseBackgroundColor = .black
        config.baseForegroundColor = .white
        confirmBtn.configuration = config
        return confirmBtn
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
    }
    
    
    //MARK: -SetUp
    private func setupViews() {
        view.addSubview(headTitle)
        view.addSubview(divider)
        view.addSubview(usernameLbl)
        view.addSubview(usernameField)
        view.addSubview(divider2)
        view.addSubview(genderLbl)
        view.addSubview(genderSegmentedControl)
        view.addSubview(divider3)
        view.addSubview(birthDayLbl)
        view.addSubview(birthdayInput)
        view.addSubview(confirmBtn)
        
        usernameField.text = username
        
        if gender == "Male" {
            genderSegmentedControl.selectedSegmentIndex = 0
        } else if gender == "Female" {
            genderSegmentedControl.selectedSegmentIndex = 1
        } else {
            genderSegmentedControl.selectedSegmentIndex = 2
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: birthday) {
            birthdayInput.date = date
        }
        
        confirmBtn.addTarget(self, action: #selector(confirmBtnTapped), for: .touchUpInside)

        
        NSLayoutConstraint.activate([
            headTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            
            divider.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            divider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            divider.topAnchor.constraint(equalTo: headTitle.bottomAnchor, constant: 10),
            divider.heightAnchor.constraint(equalToConstant: 1.5),
            
            usernameLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            usernameLbl.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 15),
            
            usernameField.leadingAnchor.constraint(equalTo: usernameLbl.trailingAnchor, constant: 16),
            usernameField.centerYAnchor.constraint(equalTo: usernameLbl.centerYAnchor),
            usernameField.widthAnchor.constraint(equalToConstant: 130),
            
            divider2.leadingAnchor.constraint(equalTo: usernameLbl.trailingAnchor, constant: 15),
            divider2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            divider2.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 10),
            divider2.heightAnchor.constraint(equalToConstant: 1),
            
            genderLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            genderLbl.topAnchor.constraint(equalTo: usernameLbl.bottomAnchor, constant: 30),
            
            genderSegmentedControl.leadingAnchor.constraint(equalTo: usernameLbl.trailingAnchor, constant: 15),
            genderSegmentedControl.centerYAnchor.constraint(equalTo: genderLbl.centerYAnchor),
            
            divider3.leadingAnchor.constraint(equalTo: usernameLbl.trailingAnchor, constant: 15),
            divider3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            divider3.topAnchor.constraint(equalTo: genderSegmentedControl.bottomAnchor, constant: 10),
            divider3.heightAnchor.constraint(equalToConstant: 1),
            
            birthDayLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            birthDayLbl.topAnchor.constraint(equalTo: genderLbl.bottomAnchor, constant: 40),
            
            birthdayInput.leadingAnchor.constraint(equalTo: usernameLbl.trailingAnchor, constant: 15),
            birthdayInput.centerYAnchor.constraint(equalTo: birthDayLbl.centerYAnchor),
            
            confirmBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmBtn.widthAnchor.constraint(equalToConstant: 95),
            confirmBtn.topAnchor.constraint(equalTo: birthdayInput.bottomAnchor, constant: 28),
        ])
    }
    
    @objc private func confirmBtnTapped() {
        let updatedUsername = usernameField.text ?? ""
        let selectedGender = genderSegmentedControl.titleForSegment(at: genderSegmentedControl.selectedSegmentIndex) ?? ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let updatedBirthday = dateFormatter.string(from: birthdayInput.date)

        guard !updatedUsername.isEmpty, updatedUsername.count > 6, updatedUsername.count < 20 else {
            let alert = UIAlertController(title: "Message", message: "Username cannot be empty and must be between 6 and 20 characters long.", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                alert.dismiss(animated: true)
            }
            return
        }

        viewmodel.updateProfileInfo(username: updatedUsername, gender: selectedGender, birthday: updatedBirthday) { [weak self] result in
            guard let self = self else { return }

            if result {
                let alert = UIAlertController(title: "", message: "Update successfully!", preferredStyle: .alert)
                alert.setMessage(font: UIFont.systemFont(ofSize: 13), color: .systemGreen)
                self.present(alert, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    alert.dismiss(animated: true) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } else {
                let alert = UIAlertController(title: "", message: "Update failed", preferredStyle: .alert)
                alert.setMessage(font: UIFont.systemFont(ofSize: 13), color: .systemRed)
                self.present(alert, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    alert.dismiss(animated: true)
                }
            }
        }
    }

}



