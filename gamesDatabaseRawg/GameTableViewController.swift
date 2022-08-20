//
//  GameTableViewController.swift
//  rawgGamesSearch
//
//  Created by Artem Kvashnin on 15.08.2022.
//

import UIKit

class GameTableViewController: UITableViewController {
    
    var games: [Game] = []
    
    let searchController = UISearchController()
    let queryService = QueryService()
    
    lazy var tapRecognizer: UITapGestureRecognizer  = {
        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        return tapGestureRecogniser
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.showsCancelButton = false
        
        tableView.register(GameTableViewCell.self, forCellReuseIdentifier: GameTableViewCell.reuseIdentifier)
        
        queryService.getSearchResults(searchTerm: "Cyberpunk 2077") { games in
            guard let games = games else { return }

            self.games = games
            self.tableView.reloadData()
        }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return games.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GameTableViewCell.reuseIdentifier, for: indexPath) as! GameTableViewCell
        let game = games[indexPath.row]
        cell.configureCell(with: game, queryService: queryService, indexPath: indexPath)
        
//        queryService.fetchImage(for: game, at: indexPath) { image in
//            let config = cell.contentConfiguration
//
//        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension GameTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.text, !searchTerm.isEmpty else { return }
//        queryService.getSearchResults(searchTerm: searchTerm) { games in
//            guard let games = games else { return }
//
//            self.games = games
//            self.tableView.reloadData()
//        }
    }
}

extension GameTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.view.removeGestureRecognizer(tapRecognizer)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }
        queryService.getSearchResults(searchTerm: searchTerm) { games in
            guard let games = games else { return }
            
            self.games = games
            self.tableView.reloadData()
        }
    }
}

extension GameTableViewController {
    @objc func dismissKeyboard() {
        searchController.searchBar.resignFirstResponder()
    }
}
