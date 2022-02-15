//
//  EditProfileTableViewController.swift
//  Messenger
//
//  Created by Олег Федоров on 15.02.2022.
//

import UIKit

class EditProfileTableViewController: UITableViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.sectionHeaderTopPadding = 0
        
        showUserInfo()
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
        return section == 0 ? 0.0 : 10.0
    }
    
    // MARK: - UpdateUI
    private func showUserInfo() {
        
        if let user = User.currentUser {
            userNameTextField.text = user.userName
            statusLabel.text = user.status
            
            if user.avatarLink != "" {
                // set avatar
            }
        }
    }
}
