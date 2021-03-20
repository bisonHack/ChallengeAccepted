//
//  WorkoutCell.swift
//  ChallengeAccepted
//
//  Created by Subomi Popoola on 3/19/21.
//

import UIKit

class WorkoutCell: UICollectionViewCell {
    
    @IBOutlet weak var workoutImage: UIImageView!
    
    func setImage(imageName: String) {
        let image = UIImage(named: imageName)
        self.workoutImage.image = image
    }
    
}
