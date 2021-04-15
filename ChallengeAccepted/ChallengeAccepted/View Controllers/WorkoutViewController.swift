//
//  WorkoutViewController.swift
//  ChallengeAccepted
//
//  Created by Subomi Popoola on 3/19/21.
//

import UIKit
import Parse

class WorkoutViewController: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var workOuts: [String] = []
    var randUser: PFUser!
    var timeTrack = 0
    var timer = Timer()
    var activityView: UIActivityIndicatorView!
    
    var solo: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        editCollectionViewLayout()

        self.workOuts = ["pushups2", "jumping", "stretch", "newsquat", "lunge", "sprint"]
        self.collectionView.reloadData()

    }
    
    func notImplementedAlert(){
        let alert = UIAlertController(title: "Coming soon", message: "Feature on the rise", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)

        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
          // your code with delay
          alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func editCollectionViewLayout(){
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
                
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2.5) / 2
        layout.itemSize = CGSize(width: width, height: width * 1.125)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.workOuts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "WorkoutCell",
                                                           for: indexPath) as! WorkoutCell
        cell.setImage(imageName: self.workOuts[indexPath.row])
        if (self.workOuts[indexPath.row] == "pushups2"){
            cell.workoutName.text = "Push-ups"
        }
        else if (self.workOuts[indexPath.row] == "jumping"){
            cell.workoutName.text = "Squat Jumps"
        }
        else if (self.workOuts[indexPath.row] == "stretch"){
            cell.workoutName.text = "Oblique Stretch"
        }
        else if (self.workOuts[indexPath.row] == "newsquat"){
            cell.workoutName.text = "Squat"
        }
        else if (self.workOuts[indexPath.row] == "lunge"){
            cell.workoutName.text = "Lunges"
        }
        else if (self.workOuts[indexPath.row] == "sprint"){
            cell.workoutName.text = "Sprint"
        }
        else {
            cell.workoutName.text = self.workOuts[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (self.workOuts[indexPath.row] == "squats") {
            if (solo) {
                self.performSegue(withIdentifier: "soloSegue", sender: nil)
            } else {
                self.performSegue(withIdentifier: "multiSegue", sender: nil)
            }
        } else{
            self.notImplementedAlert()
        }
    }

    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "randChallengeSegue"){
            let randChallengeController = segue.destination as! ChallengeViewController
            randChallengeController.opponent = randUser
        }
    }
 */

}
