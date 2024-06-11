//
//  SearchViewController.swift
//  FilmValley
//
//  Created by Trịnh Kiết Tường on 08/04/2024.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    private var viewModel: FilmViewModels!
    
    
    //MARK: -UI
    
    private let searchInput: UITextField = {
        let search = UITextField()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.borderStyle = .roundedRect
        search.placeholder = " Type your film..."
        search.layer.cornerRadius = 13
        return search
    }()
    
    private let tableView:UITableView = {
        let tableView = UITableView()
        tableView.register(FilmCell.self, forCellReuseIdentifier: "FilmCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var filteredFilms: [Film] = []
    
    //MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        setUp()
        viewModel = FilmViewModels()
        viewModel.fetchDataFromFirebase {
            self.filteredFilms = self.viewModel.filmsArray
            self.tableView.reloadData()
        }
        tableView.isHidden = true
        
    }
    
    
    //MARK: -SetUp
    private func setUp() {
        view.addSubview(searchInput)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchInput.delegate = self
        searchInput.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        NSLayoutConstraint.activate([
            searchInput.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 15),
            searchInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            searchInput.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchInput.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchInput.bottomAnchor,constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        filterFilmsWithKeyword(textField.text)
    }
    
    private func filterFilmsWithKeyword(_ keyword: String?) {
        guard let keyword = keyword?.lowercased(), !keyword.isEmpty else {
            filteredFilms = []
            tableView.reloadData()
            return
        }
        filteredFilms = viewModel.filmsArray.filter { $0.title.lowercased().contains(keyword) }
        var uniqueFilms: [Film] = []
        for film in filteredFilms {
            if !uniqueFilms.contains(where: { $0.title == film.title }) {
                uniqueFilms.append(film)
            }
        }
        filteredFilms = uniqueFilms
        tableView.isHidden = false
        tableView.reloadData()
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilmCell", for: indexPath) as! FilmCell
        let film = filteredFilms[indexPath.row]
        let imageUrl = film.imageUrl
        cell.filmImageView.downloaded(from: imageUrl)
        cell.titleLabel.text = film.title
        cell.directorLable.text = "Directed by \(film.director)"
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFilms.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFilm = filteredFilms[indexPath.row]
        let detailVC = DetailViewController(film: selectedFilm)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

