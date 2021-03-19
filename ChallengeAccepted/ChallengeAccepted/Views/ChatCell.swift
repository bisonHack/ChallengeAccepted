//
//  ChatCell.swift
//  ChallengeAccepted
//
//  Created by Subomi Popoola on 3/19/21.
//

import UIKit
import Parse

class ChatCell: UITableViewCell {



    @IBOutlet weak var profileImage: PFImageView!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUser(user: PFObject) {
        self.usernameLabel.text = user["username"] as? String
        self.profileImage.layer.borderWidth = 1.0
        self.profileImage.layer.masksToBounds = false
        self.profileImage.layer.borderColor = UIColor.gray.cgColor
        self.profileImage.layer.cornerRadius = 1.0
        self.profileImage.clipsToBounds = true
        let imageData = user.object(forKey: "image") as? PFFileObject
        self.profileImage.file = imageData
        self.profileImage.loadInBackground()
        self.chatView.layer.cornerRadius = 8.0
        self.chatView.layer.masksToBounds = false
        self.chatView.layer.shadowOffset = CGSize(width: -2, height: 5)
        self.chatView.layer.shadowRadius = 1.5
        self.chatView.layer.shadowOpacity = 0.5
    }

}
