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
        configureTextField()
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
        //TODO: show status view
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
    
    // MARK: - Configure
    private func configureTextField() {
        userNameTextField.delegate = self
        userNameTextField.clearButtonMode = .whileEditing
    }
}

extension EditProfileTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == userNameTextField {
            
            if textField.text != "" {
                
                if var user = User.currentUser {
                    user.userName = textField.text ?? ""
                    saveUserLocally(user)
                    FirebaseUserListener.shared.saveUserToFirestore(user)
                }
            }
            
            textField.resignFirstResponder()
            return false
        }
        
        return true
    }
}
