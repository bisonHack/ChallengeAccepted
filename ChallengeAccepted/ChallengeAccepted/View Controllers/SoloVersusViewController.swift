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
        self.performSegue(withIdentifier: "soloSegue", sender: nil)
    }
    
    
    @IBAction func didTapChallenge(_ sender: Any) {
        self.performSegue(withIdentifier: "multiSegue", sender: nil)

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "multiSegue") {
            let viewController = segue.destination as! UINavigationController
            let targetController = viewController.topViewController as! MainFeedViewController
            targetController.solo = false
        } else {
            let viewController = segue.destination as! UINavigationController
            let targetController = viewController.topViewController as! WorkoutViewController
            targetController.solo = true
        }
    }


}
