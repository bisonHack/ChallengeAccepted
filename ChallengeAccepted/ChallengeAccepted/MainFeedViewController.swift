//
//  MainFeedViewController.swift
//  ChallengeAccepted
//
//  Created by Ayo  on 4/14/21.
//

import UIKit

class MainFeedViewController: UIViewController {


    
    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    
    override func viewDidLoad() {
        
       image1.layer.masksToBounds = true
        image1.layer.cornerRadius = image1.bounds.width / 2.5
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    

    
    

    @IBAction func shareAll(_ sender: Any) {
        let text = "Ayo is inviting to you to join her Squat Challenge"
        let image = UIImage(named: "logo3")
        let myWebsite = NSURL(string:"https://ChallengeAccepted.com")
         let shareAll = [text, image, myWebsite as Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
