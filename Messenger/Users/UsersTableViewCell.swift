//
//  UsersTableViewCell.swift
//  Messenger
//
//  Created by Олег Федоров on 21.02.2022.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func configureCell(withUser user: User) {
        
        usernameLabel.text = user.userName
        statusLabel.text = user.status
        setAvatar(avatarLink: user.avatarLink)
    }
    
    private func setAvatar(avatarLink: String) {
        
        if avatarLink != "" {
            FileStorage.downloadImage(imageUrl: avatarLink) { [weak self] avatarImage in
                self?.avatarImageView.image = avatarImage
            }
        } else {
            avatarImageView.image = UIImage(named: "avatar")?.circleMasked
        }
    }
}
