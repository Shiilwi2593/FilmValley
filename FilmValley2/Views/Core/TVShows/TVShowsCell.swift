//
//  TVShowsCell.swift
//  FilmValley2
//
//  Created by Trịnh Kiết Tường on 18/06/2024.
//

import UIKit

class TVShowsCell: UICollectionViewCell {
    
    var image: UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "images")
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        return image
    }()
    
    var title: UILabel = {
       let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        title.textAlignment = .left
        title.numberOfLines = 1
        return title
    }()
    
    var creator: UILabel = {
        let creator = UILabel()
        creator.translatesAutoresizingMaskIntoConstraints = false
        creator.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        creator.textColor = .systemGray2
        creator.textAlignment = .left
        creator.numberOfLines = 1
        return creator
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.addSubview(title)
        contentView.addSubview(image)
        contentView.addSubview(creator)
        
        
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 13),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -13),
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            image.heightAnchor.constraint(equalToConstant: 165),
            
            title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 4),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 13),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            title.heightAnchor.constraint(equalToConstant: 15),
            
            creator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 13),
            creator.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 3),
            creator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
