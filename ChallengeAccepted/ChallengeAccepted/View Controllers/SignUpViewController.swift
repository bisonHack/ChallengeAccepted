//
//  SignUpViewController.swift
//  ChallengeAccepted
//
//  Created by Ayo  on 4/7/21.
//

import UIKit
import Parse

//blahblahblah

class SignUpViewController: UIViewController {
    
//    @IBOutlet weak var firstName: UITextField!
//    @IBOutlet weak var lastName: UITextField!
//    @IBOutlet weak var usernameField: UITextField!
//    @IBOutlet weak var password: UITextField!
//    @IBOutlet weak var signUp: UIButton!

    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signUp: UIButton!
    
    @IBAction func onSignUp(_ sender: Any) {
        let user = PFUser()
        user.username = username.text!
        user.password = password.text!
//        self.performSegue(withIdentifier: "second", sender: nil);
        user.signUpInBackground { (success, error) in
            if success {
                self.firstName.text?.removeAll()
                self.lastName.text?.removeAll()
                self.username.text?.removeAll()
                self.password.text?.removeAll()
//
            } else {
                let alert = UIAlertController(title: "Incomplete Details", message: "Please add your sign up details", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print("Error \(error?.localizedDescription)")
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        
    
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
}
