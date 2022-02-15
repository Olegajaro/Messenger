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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.sectionHeaderTopPadding = 0
    }
   
    // MARK: - Loading status
    private func loadUserStatus() {
        allStatuses = userDefaults.object(forKey: KEY_STATUS) as! [String]
        tableView.reloadData()
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

        cell.accessoryType = currentUserStatus == status ? .checkmark : .none
        content.text = status

        cell.contentConfiguration = content
        return cell
    }
    
}
