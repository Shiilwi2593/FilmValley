//
//  WelcomeScreenViewController.swift
//  FilmValley
//
//  Created by Trịnh Kiết Tường on 07/04/2024.
//

import UIKit

class WelcomeScreenViewController: UIViewController{

    private var image: UIImageView = {
        let image = UIImageView()
        let centerX = UIScreen.main.bounds.width / 2
        let centerY = UIScreen.main.bounds.height / 2
        image.frame = CGRect(x:centerX - 500 / 2, y: centerY - 500 / 2, width: 500 , height: 500)
        image.image = UIImage(named: "welcomeImg")
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(image)
    }
}
