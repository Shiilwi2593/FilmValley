//
//  SceneDelegate.swift
//  FilmValley
//
//  Created by Trịnh Kiết Tường on 07/04/2024.
//

import UIKit
import Foundation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.windowScene = windowScene
        let vc = WelcomeScreenViewController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.navigationBar.isHidden = true
            UIView.transition(with: self.window!, duration: 0.5, options: .transitionCurlUp) {
                self.window?.rootViewController = nav
            }
        }
    
//      grayl
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
    
    
}

