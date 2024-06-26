//
//  ListTvSeriesViewController.swift
//  FilmValley2
//
//  Created by Trịnh Kiết Tường on 18/06/2024.
//

import UIKit

class ListTvShowController: UIViewController {
    
    private var tvShowViewModels: ListTvShowViewModel = ListTvShowViewModel()
    
    // MARK: - UI
    private var tvshowlistVw: UICollectionView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TV Shows"
        view.backgroundColor = .systemBackground
        setUp()
    }
    
    // MARK: - SetUp
    private func setUp() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width / 2 - 25, height: 225)
        layout.minimumLineSpacing = 25
        
        tvshowlistVw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tvshowlistVw.translatesAutoresizingMaskIntoConstraints = false
        
        tvshowlistVw.delegate = self
        tvshowlistVw.dataSource = self
        
        tvshowlistVw.register(TVShowsCell.self, forCellWithReuseIdentifier: "TVShowsCell")
        
        view.addSubview(tvshowlistVw)
        NSLayoutConstraint.activate([
            tvshowlistVw.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tvshowlistVw.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tvshowlistVw.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tvshowlistVw.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        tvShowViewModels.fetchDataFromFirebase {
            DispatchQueue.main.async {
                self.tvshowlistVw.reloadData()
                print("Number of TvShow: \(self.tvShowViewModels.getLength())")
            }
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ListTvShowController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tvShowViewModels.getLength()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tvShow = self.tvShowViewModels.tvShowArray[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TVShowsCell", for: indexPath) as! TVShowsCell
        cell.title.text = tvShow.title
        cell.image.downloaded(from: tvShow.imageUrl, contentMode: .scaleToFill) 
        cell.creator.text = tvShow.creator
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTVShows = tvShowViewModels.tvShowArray[indexPath.row]
        let vc = DetailTVShowsViewController(tvShow: selectedTVShows)
        navigationController?.pushViewController(vc, animated: true)
        navigationItem.backButtonTitle = ""
    }
}
