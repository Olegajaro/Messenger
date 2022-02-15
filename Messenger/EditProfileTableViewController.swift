//
//  EditProfileTableViewController.swift
//  Messenger
//
//  Created by Олег Федоров on 15.02.2022.
//

import UIKit
import Gallery

class EditProfileTableViewController: UITableViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    
    // MARK: - Variables
    var gallery: GalleryController!
    
    
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
    
    // MARK: - IBActions
    @IBAction func editButtonPressed(_ sender: Any) {
        showImageGallery()
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
    
    // MARK: - Gallery
    private func showImageGallery() {
        
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        
        present(gallery, animated: true, completion: nil)
    }
    
    // MARK: - Upload images
    private func uploadAvatarImage(_ image: UIImage) {
        
        let fileDirectory = "Avatars/" + "_\(User.currentId)" + ".jpg"
        FileStorage.uploadImage(image, directory: fileDirectory) { avatarLink in
            
            if var user = User.currentUser {
                user.avatarLink = avatarLink ?? ""
                saveUserLocally(user)
                FirebaseUserListener.shared.saveUserToFirestore(user)
            }
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                FileStorage.saveFileLocally(
                    fileData: imageData as NSData,
                    fileName: User.currentId
                )
            }
        }
    }
}

// MARK: - UITextFieldDelegate
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

// MARK: - GalleryControllerDelegate
extension EditProfileTableViewController: GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController,
                           didSelectImages images: [Image]) {
        
        if images.count > 0 {
            
            images.first!.resolve { [unowned self] avatarImage in
                
                if avatarImage != nil {
                    self.uploadAvatarImage(avatarImage!)
                    self.avatarImageView.image = avatarImage
                } else {
                    ProgressHUD.showError("Couldn't select image!")
                }
            }
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController,
                           didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController,
                           requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
