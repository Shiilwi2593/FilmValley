//
//  ViewController.swift
//  FilmValley
//
//  Created by Trịnh Kiết Tường on 07/04/2024.
//

import UIKit
import Firebase
import FirebaseAuth

class ListMovieViewController: UIViewController {
    
    private var filmViewModels: FilmViewModels = FilmViewModels()
    
    //MARK: - UI
    private let tableView: UITableView = {
        let tableVw = UITableView()
        tableVw.register(FilmCell.self, forCellReuseIdentifier: "FilmCell")
        return tableVw
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // NavBar
        title = "Movies"
        view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        setUp()
    }
    
    //MARK: - Setup
    private func setUp() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        filmViewModels.fetchDataFromFirebase {
            self.tableView.reloadData()
            print("Number of films: \(self.filmViewModels.getLength())")
        }
    }
}

extension ListMovieViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmViewModels.getLength()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilmCell", for: indexPath) as! FilmCell
        let film = filmViewModels.filmsArray[indexPath.row]
        cell.filmImageView.downloaded(from: film.imageUrl)
        cell.titleLabel.text = film.title
        cell.directorLable.text = "Directed by \(film.director)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFilm = filmViewModels.filmsArray[indexPath.row]
        let detailVC = DetailViewController(film: selectedFilm)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}



