//
//  UsersTableViewController.swift
//  Messenger
//
//  Created by Олег Федоров on 21.02.2022.
//

import UIKit

class UsersTableViewController: UITableViewController {

    // MARK: - Variables
    var allUsers: [User] = []
    var filteredUsers: [User] = []
    
    let firebaseUserListener = FirebaseUserListener.shared
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        createDummyUsers()
        setupSearchController()
        downloadUsers()
        tableView.rowHeight = 80
    }
    
    // MARK: - Download Users
    private func downloadUsers() {
        firebaseUserListener.downloadAllUsersFromFirebase { [weak self] allUsers in
            self?.allUsers = allUsers
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Setup search controller
    private func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search user"
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
    }
    
    private func filteredContentForSearchText(searchText: String) {
        
        filteredUsers = allUsers.filter { user -> Bool in
            return user.userName.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredUsers.count : allUsers.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "userCell",
            for: indexPath
        ) as! UsersTableViewCell
        
        let user = searchController.isActive
        ? filteredUsers[indexPath.row]
        : allUsers[indexPath.row]
        
        cell.configureCell(withUser: user)

        return cell
    }
}

// MARK: - UISearchResultsUpdating
extension UsersTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filteredContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
