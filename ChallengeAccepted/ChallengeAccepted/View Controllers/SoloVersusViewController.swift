//
//  SoloVersusViewController.swift
//  ChallengeAccepted
//
//  Created by Subomi Popoola on 4/14/21.
//

import UIKit

class SoloVersusViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapSolo(_ sender: Any) {
        
    }
    
    
    @IBAction func didTapChallenge(_ sender: Any) {
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "soloSegue") {
            let viewController = segue.destination as! UINavigationController
            let targetController = viewController.topViewController as! MainFeedViewController
         
        }
    }


}
