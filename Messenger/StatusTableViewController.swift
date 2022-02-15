//
//  StatusTableViewController.swift
//  Messenger
//
//  Created by Олег Федоров on 15.02.2022.
//

import UIKit

class StatusTableViewController: UITableViewController {

    // MARK: - Variables
    var allStatuses: [String] = []
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.sectionHeaderTopPadding = 0
        loadUserStatus()
    }
   
    // MARK: - Table view data source
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        allStatuses.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "statusCell", for: indexPath
        )
        var content = cell.defaultContentConfiguration()
        
        let status = allStatuses[indexPath.row]
        let currentUserStatus = User.currentUser?.status
        
        content.text = status

        cell.accessoryType = currentUserStatus == status ? .checkmark : .none
        cell.contentConfiguration = content
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        updateCellCheck(indexPath)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "TableViewBackgroundColor")
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    // MARK: - Loading status
    private func loadUserStatus() {
        allStatuses = userDefaults.object(forKey: KEY_STATUS) as! [String]
        tableView.reloadData()
    }
    
    private func updateCellCheck(_ indexPath: IndexPath) {
        
        if var user = User.currentUser {
            user.status = allStatuses[indexPath.row]
            saveUserLocally(user)
            FirebaseUserListener.shared.saveUserToFirestore(user)
        }
    }
}
