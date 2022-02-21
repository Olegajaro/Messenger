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
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        createDummyUsers()
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
