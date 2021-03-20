//
//  FoodViewController.swift
//  ChallengeAccepted
//
//  Created by Subomi Popoola on 3/20/21.
//

import UIKit
import CoreML

class FoodViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var clickPrompt: UILabel!
    @IBOutlet weak var label: UILabel!
    
    var id = ""
    var food = ""
    var classifiedData = ""
    var foodID = ""
    var foodName:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextBtn.isHidden = true
        label.isHidden = true
        segmentedController.isHidden = true
        clickPrompt.isHidden = true
    }
    
    @IBAction func didTapNext(_ sender: Any) {
    }
    
    
    @IBAction func segmentedValueChanged(_ sender: Any) {
        if (self.segmentedController.selectedSegmentIndex == 0) {
            self.nextBtn.isHidden = false
            clickPrompt.text = "Click the next button"
        } else if (self.segmentedController.selectedSegmentIndex == 1) {
            clickPrompt.text = "We are still working our improving our application"
        }
    }
    
    @IBAction func imgButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let imagePickerView = UIImagePickerController()
        imagePickerView.delegate = self

        alert.addAction(UIAlertAction(title: "Choose Image", style: .default) { _ in
            imagePickerView.sourceType = .photoLibrary
            self.present(imagePickerView, animated: true, completion: nil)
        })

        alert.addAction(UIAlertAction(title: "Take Image", style: .default) { _ in
            imagePickerView.sourceType = .camera
            self.present(imagePickerView, animated: true, completion: nil)
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        dismiss(animated: true, completion: nil)

        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else {
            return
        }

        processImage(image)
    }

    func processImage(_ image: UIImage) {
        let model = Food101()
        let size = CGSize(width: 299, height: 299)

        guard let buffer = image.resize(to: size)?.pixelBuffer() else {
            fatalError("Scaling or converting to pixel buffer failed!")
        }

        guard let result = try? model.prediction(image: buffer) else {
            fatalError("Prediction failed!")
        }

        let confidence = result.foodConfidence["\(result.classLabel)"]! * 100.0
        let converted = String(format: "%.2f", confidence)

        imageView.image = image
        percentageLabel.text = "\(result.classLabel) - \(converted) %"
        self.classifiedData = result.classLabel
        
        segmentedController.isHidden = false
        nextBtn.isHidden = true
        label.isHidden = false
    
        
        
        
       
        
        
        foodData()
//        print(self.classifiedData)
       
        
        
    }
    

    
    func foodData(){
        
        
        
        let query = self.classifiedData
        let url = URL(string:"https://api.spoonacular.com/recipes/autocomplete?number=10&query=" + query + "&apiKey=c4295465101844b6bdb8ae9b78be04ee")!

        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
                     // This will run when the network request returns
        if let error = error {
                print(error.localizedDescription)
 
        } else if let data = data {
            let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! NSArray
            
            print(dataDictionary.count)
            
            var start = 0
         
            
            while start < dataDictionary.count{
                let item = dataDictionary[start] as! [String:Any]
                for _ in item{
                    self.id = String(format:"%@", item["id"] as! CVarArg)
                    self.food = item["title"]  as! String
                    if self.food == self.classifiedData{
                        print(self.classifiedData)
                        print(self.food)
                        self.foodID = self.id
                        self.foodName = self.food
                        
                        print(self.foodID)
                        break
                    } else{
                        continue
                    }
                }
                start += 1
            }
           
            print(self.foodID)
            
        }
        
           
            
    }
        task.resume()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is NutritionViewController{
         let nutritionViewController = segue.destination as! NutritionViewController
         nutritionViewController.foodID = foodID
            nutritionViewController.foodName = foodName
        
   
        }
        
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
