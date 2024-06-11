//
//  FilmCell.swift
//  FilmValley
//
//  Created by Trịnh Kiết Tường on 08/04/2024.
//

import UIKit

class FilmCell: UITableViewCell {
    
    let filmImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Impact", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let directorLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(filmImageView)
        addSubview(titleLabel)
        addSubview(directorLable)
        
        NSLayoutConstraint.activate([
            filmImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            filmImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            filmImageView.heightAnchor.constraint(equalToConstant: 130),
            filmImageView.widthAnchor.constraint(equalToConstant: 130),
            
            titleLabel.leadingAnchor.constraint(equalTo: filmImageView.trailingAnchor, constant: 0),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -15),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            directorLable.leadingAnchor.constraint(equalTo: filmImageView.trailingAnchor, constant: 0),
            directorLable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented!")
    }
}

