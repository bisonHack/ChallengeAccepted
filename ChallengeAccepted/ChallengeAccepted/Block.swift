//
//  Block.swift
//  ChallengeAccepted
//
//  Created by Ayo  on 4/14/21.
//

import Foundation
import UIKit


@IBDesignable class BlockView : UIView {
    @IBInspectable
    var cornerRadius : CGFloat = 20
    var offsetWidth : CGFloat = 5
    var offsetHeight : CGFloat = 5
    
    var offsetShadowOpacity : Float = 5
    @IBInspectable
    var color = UIColor.systemGray4
    
    
    override func layoutSubviews() {
        layer.cornerRadius = self.cornerRadius
        layer.shadowColor = self.color.cgColor
        layer.shadowOffset = CGSize(width: self.offsetWidth, height: self.offsetHeight)
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.cornerRadius).cgPath
        layer.shadowOpacity = self.offsetShadowOpacity
        
        
    }
    
    
}
