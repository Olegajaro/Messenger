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
        
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
//        createDummyUsers()
        setupSearchController()
        downloadUsers()
        tableView.rowHeight = 80
        tableView.sectionHeaderTopPadding = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
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
    
    // MARK: - UIScrollViewDelegate
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if refreshControl!.isRefreshing {
            downloadUsers()
            refreshControl!.endRefreshing()
        }
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
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "TableViewBackgroundColor")
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForHeaderInSection section: Int) -> CGFloat {
        5
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let user = searchController.isActive
        ? filteredUsers[indexPath.row]
        : allUsers[indexPath.row]
        
        showUserProfile(user)
    }
    
    // MARK: - Navigation
    private func showUserProfile(_ user: User) {
        
        let profileView = UIStoryboard(
            name: "Main", bundle: nil
        ).instantiateViewController(
            withIdentifier: "ProfileView"
        ) as! ProfileTableViewController
        
        profileView.user = user
        self.navigationController?.pushViewController(profileView,
                                                      animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension UsersTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filteredContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
