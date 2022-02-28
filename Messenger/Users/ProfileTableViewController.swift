//
//  ProfileTableViewController.swift
//  Messenger
//
//  Created by Олег Федоров on 26.02.2022.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    // MARK: - Variables
    var user: User?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        tableView.sectionHeaderTopPadding = 0
        
        setupUI()
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        
        if user != nil {
            title = user!.userName
            usernameLabel.text = user!.userName
            statusLabel.text = user!.status
            
            if user!.avatarLink != "" {
                FileStorage.downloadImage(
                    imageUrl: user!.avatarLink
                ) { [weak self] image in
                    self?.avatarImageView.image = image?.circleMasked
                }
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            print("DEBUG: start chat")
            // TODO: go to chat room
        }
    }
    
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
                            heightForFooterInSection section: Int) -> CGFloat {
        0
    }
}
