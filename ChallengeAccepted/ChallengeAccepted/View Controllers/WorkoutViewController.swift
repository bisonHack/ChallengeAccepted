//
//  WorkoutViewController.swift
//  ChallengeAccepted
//
//  Created by Subomi Popoola on 3/19/21.
//

import UIKit

class WorkoutViewController: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var workOuts: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        editCollectionViewLayout()

        self.workOuts = ["pushUps", "inclinePushUps", "declinePushUps", "squats", "pullUps", "sprints"]
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
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
