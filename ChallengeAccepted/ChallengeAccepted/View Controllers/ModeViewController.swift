//
//  ModeViewController.swift
//  ChallengeAccepted
//
//  Created by Subomi Popoola on 4/10/21.
//

import UIKit
import Parse

class ModeViewController: UIViewController {

    
    @IBOutlet weak var hamburgerImg: UIImageView!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var challengeLabel: UILabel!
    @IBOutlet weak var maxRepsBtn: UIButton!
    @IBOutlet weak var raceBtn: UIButton!
    @IBOutlet weak var soloBtn: UIButton!
    @IBOutlet weak var backgroundImg: UIImageView!
    
    var randUser: PFUser!
    var timeTrack = 0
    var timer = Timer()
    var activityView: UIActivityIndicatorView!
    var segueType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        PFUser.current()?.setObject(false, forKey: "Looking")
        PFUser.current()?.setObject(0, forKey: "currentCount")
        PFUser.current()?.saveInBackground()
    }
    
    func wrongUserAlert() {
        let alert = UIAlertController(title: "Invalid Details", message: "The username or password is incorrect", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loginUser(username: String, password: String) {
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if (user == nil){
                self.wrongUserAlert()
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    func notImplementedAlert(){
        let alert = UIAlertController(title: "Coming soon...", message: "Feature on the rise", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)

        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when) {
          // your code with delay
          alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func setupUI() {
        self.backgroundImg.frame = view.frame
        
        self.hamburgerImg.frame.origin.x = 20.0
        self.hamburgerImg.frame.origin.y = 60.0
        self.hamburgerImg.sizeToFit()
        
        self.logoImg.frame.origin.x = (view.frame.size.width - 50.0)
        self.logoImg.frame.origin.y = 60.0
        self.logoImg.sizeToFit()
        
        self.challengeLabel.frame.origin.x = (view.frame.size.width - self.challengeLabel.frame.size.width) / 2.0
        self.challengeLabel.frame.origin.y = 185.0
        self.challengeLabel.sizeToFit()
        
//        self.maxRepsBtn.layer.cornerRadius = 20.0
//        self.maxRepsBtn.layer.borderWidth = 2.0
//        self.maxRepsBtn.layer.borderColor = UIColor.black.cgColor
//        
//        self.raceBtn.layer.cornerRadius = 20.0
//        self.raceBtn.layer.borderWidth = 2.0
//        self.raceBtn.layer.borderColor = UIColor.black.cgColor
//        
//        self.soloBtn.layer.cornerRadius = 20.0
//        self.soloBtn.layer.borderWidth = 2.0
//        self.soloBtn.layer.borderColor = UIColor.black.cgColor
    }
    
    func noRandUserAlert() {
        let alert = UIAlertController(title: "Couldn't find User", message: "No user found", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)

        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
          // your code with delay
          alert.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func getRandUser() {
        let query = PFUser.query()!
        query.whereKey("username", notEqualTo: PFUser.current()?.username!)
        query.whereKey("Looking", equalTo: true)
        query.findObjectsInBackground { (objects, error) in
            if (error == nil) {
                self.timeTrack += 1
                if (!objects!.isEmpty) {
                    self.randUser = (objects![0] as! PFUser)
                    self.timer.invalidate()
                    self.activityView.stopAnimating()
                    self.performSegue(withIdentifier: self.segueType, sender: nil)
                } else {
                    if (self.timeTrack == 20) {
                        self.timer.invalidate()
                        self.activityView.stopAnimating()
                        self.timeTrack = 0
                        self.noRandUserAlert()
                        PFUser.current()?.setObject(false, forKey: "Looking")
                        PFUser.current()?.saveInBackground()
                    }
                }
            }
        }
    }
    
    func showActivityIndicatory() {
        let container: UIView = UIView()
        container.frame = CGRect(x: 0, y: 0, width: 80, height: 80) // Set X and Y whatever you want
        container.backgroundColor = .clear

        activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityView.center = self.view.center

        container.addSubview(activityView)
        self.view.addSubview(container)
        activityView.startAnimating()
    }
    
    func looking() {
        showActivityIndicatory()
        PFUser.current()?.setObject(true, forKey: "Looking")
        PFUser.current()?.saveInBackground()
        self.timer = Timer.scheduledTimer(timeInterval: 1,
            target: self,
            selector: #selector(getRandUser),
            userInfo: nil,
            repeats: true)
    }
    
    
    @IBAction func didTapMaxRep(_ sender: Any) {
        self.segueType = "60sRep"
        looking()
    }
    
    @IBAction func didTapRace(_ sender: Any) {
        self.segueType = "100Reps"
        looking()
    }
    
    @IBAction func didTapSolo(_ sender: Any) {
        notImplementedAlert()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "100Reps") {
            let viewController = segue.destination as! Rep100ViewController
            viewController.randomUser = randUser
        } else {
            let viewController = segue.destination as! Rep60sViewController
            viewController.randomUser = randUser
        }
    }
    
}
