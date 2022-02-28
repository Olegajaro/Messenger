//
//  RecentTableViewCell.swift
//  Messenger
//
//  Created by Олег Федоров on 26.02.2022.
//

import UIKit

class RecentTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var unreadCounterLabel: UILabel!
    @IBOutlet weak var unreadCounterBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        unreadCounterBackgroundView.layer.cornerRadius =
        unreadCounterBackgroundView.frame.width / 2
    }
    
    func configure(recent: RecentChat) {
        usernameLabel.text = recent.receiverName
        usernameLabel.adjustsFontSizeToFitWidth = true
        usernameLabel.minimumScaleFactor = 0.9
        
        lastMessageLabel.text = recent.lastMessage
        lastMessageLabel.adjustsFontSizeToFitWidth = true
        lastMessageLabel.minimumScaleFactor = 0.9
        
        if recent.unreadCounter != 0 {
            unreadCounterLabel.text = "\(recent.unreadCounter)"
            unreadCounterBackgroundView.isHidden = false
        } else {
            unreadCounterBackgroundView.isHidden = true
        }
        
        setAvatar(avatarLink: recent.avatarLink)
        
        dateLabel.text = timeElapsed(recent.date ?? Date())
        dateLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setAvatar(avatarLink: String) {
        if avatarLink != "" {
            FileStorage.downloadImage(imageUrl: avatarLink) { [weak self] image in
                self?.avatarImageView.image = image?.circleMasked
            }
        } else {
            avatarImageView.image = UIImage(named: "avatar")?.circleMasked
        }
    }
}
