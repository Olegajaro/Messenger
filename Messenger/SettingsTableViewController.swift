//
//  SettingsTableViewController.swift
//  Messenger
//
//  Created by Олег Федоров on 14.02.2022.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var appVersionLabel: UILabel!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.sectionHeaderTopPadding = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 && indexPath.row == 0 {
            performSegue(withIdentifier: "settingsToEditProfile", sender: self)
        }
    }

    // MARK: - IBActions
    @IBAction func tellAFriendButtonPressed(_ sender: Any) {
        print("DEBUG: tell a friend")
    }
    
    @IBAction func termsAndConditionsButtonPressed(_ sender: Any) {
        print("DEBUG: show T&C")
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        FirebaseUserListener.shared.logOutCurrentUser { error in
            if error == nil {
                
                let loginView = UIStoryboard(
                    name: "Main", bundle: nil
                ).instantiateViewController(withIdentifier: "LoginView")
                
                DispatchQueue.main.async {
                    loginView.modalPresentationStyle = .fullScreen
                    self.present(loginView, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: - UpdateUI
    private func showUserInfo() {
        if let user = User.currentUser {
            let versionApp = Bundle.main.infoDictionary?[
                "CFBundleShortVersionString"
            ] as? String ?? ""
            
            userNameLabel.text = user.userName
            statusLabel.text = user.status
            appVersionLabel.text = "App version \(versionApp)"
            
            if user.avatarLink != "" {
                // download and set avatar image
                FileStorage.downloadImage(
                    imageUrl: user.avatarLink
                ) { [weak self] image in
                    self?.avatarImageView.image = image
                }
            }
        }
    }
}
