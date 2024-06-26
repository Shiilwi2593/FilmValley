//
//  TabbarViewController.swift
//  FilmValley
//
//  Created by Trịnh Kiết Tường on 07/04/2024.
//

import UIKit
import FirebaseAuth
import Firebase

class TabbarViewController: UITabBarController, UITabBarControllerDelegate {
    var currentUser: User
    
    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -LyfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = ListMovieViewController()
        let vc2 = ListTvShowController()
        let vc3 = SearchViewController()
        let vc4 = AccountInfoViewController()
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        let nav4 = UINavigationController(rootViewController: vc4)
        
        nav1.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "film.fill"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "TV Shows", image: UIImage(systemName: "film.stack.fill"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        nav4.tabBarItem = UITabBarItem(title: "Account", image: UIImage(systemName: "person"), tag: 1)
        
        tabBar.backgroundColor = .systemGray6
        
        setViewControllers([nav1, nav2, nav3, nav4], animated: false)
        
        print(currentUser.uid)
        
        self.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let currentUser = Auth.auth().currentUser {
            if !currentUser.isEmailVerified {
                currentUser.sendEmailVerification { error in
                    if let error = error {
                        print("Error sending email verification: \(error.localizedDescription)")
                        let alert = UIAlertController(title: "Email Verification", 
                                                      message: """
                                                                A verification link has been sent to your email address.
                                                                Please verify your email and refresh the app.
                                                               """,
                                                      preferredStyle: .alert)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        print("Email verification sent successfully.")
                        let alert = UIAlertController(title: "Email Verification", 
                                                      message: """
                                                                A verification link has been sent to your email address.
                                                                Please verify your email and refresh the app.
                                                               """,
                                                      preferredStyle: .alert)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            else if currentUser.isEmailVerified{
                let loadingAlert = UIAlertController(title: "", message: "Loading...", preferredStyle: .alert)
                self.present(loadingAlert, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    loadingAlert.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
}





