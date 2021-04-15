//
//  WorkoutCell.swift
//  ChallengeAccepted
//
//  Created by Subomi Popoola on 3/19/21.
//

import UIKit

class WorkoutCell: UICollectionViewCell {
    
    @IBOutlet weak var workoutImage: UIImageView!
    @IBOutlet weak var workoutName: UILabel!
    
    func setImage(imageName: String) {
        let image = UIImage(named: imageName)
        self.workoutImage.image = image
    }
    
}
