//
//  FoodCell.swift
//  ChallengeAccepted
//
//  Created by Subomi Popoola on 3/20/21.
//

import UIKit

class FoodCell: UITableViewCell {
    @IBOutlet weak var calories: UILabel!
    @IBOutlet weak var data: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
