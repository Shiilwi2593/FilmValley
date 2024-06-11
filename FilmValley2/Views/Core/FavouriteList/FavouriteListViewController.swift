//
//  FavouriteListViewController.swift
//  FilmValley2
//
//  Created by Trịnh Kiết Tường on 13/05/2024.
//

import UIKit

class FavouriteListViewController: UIViewController {
    
    private var vm = FavouriteViewModel()
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Favourite list"
        setUpCollectionView()
    }
    func reloadData(){
        fetchFavouriteData()
    }
    
    func getLengFavArray() -> Int{
        vm.getLength()
    }
    
    func updateFavouriteList(with newData: [Film]) {
        vm.filmFavArray = newData
        collectionView.reloadData()
    }
    
    private func setUpCollectionView() {
        fetchFavouriteData()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(FilmFavCell.self, forCellWithReuseIdentifier: "FilmFavCell")
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func fetchFavouriteData() {
        vm.getListFavourite { list in
            print(list ?? "")
        }
        vm.fetchFavDataFromFirebase {
            print("fetch data!")
            self.collectionView.reloadData()
        }
    }
}

extension FavouriteListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.getLength()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilmFavCell", for: indexPath) as! FilmFavCell
        let film = vm.filmFavArray[indexPath.row]
        cell.imageView.downloaded(from: film.imageUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height - 20 // Trừ đi sectionInset.top và sectionInset.bottom
        let width = height * 0.66 // Tỉ lệ width:height là 2:3
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedFilm = vm.filmFavArray[indexPath.item]
        let detailVC = DetailViewController(film: selectedFilm)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
