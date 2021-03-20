//
//  NutritionViewController.swift
//  ChallengeAccepted
//
//  Created by Subomi Popoola on 3/20/21.
//

import UIKit

class NutritionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var foodData = [[String:Any]]()
    var foodID:String = ""
    var foodName:String = ""

    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var protein: UILabel!
    @IBOutlet weak var fat: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        foodNutrientData()
        foodLabel.text = foodName    }
    
    func foodNutrientData(){
//        let foodID = food["id"] as! Int
//        let FoodID = String(foodID)
//        print("IT IS")
//        print(foodID)
        let FoodID = foodID
        let url = URL(string: "https://api.spoonacular.com/recipes/" + FoodID + "/nutritionWidget.json?apiKey=c4295465101844b6bdb8ae9b78be04ee")!
//
//        let url = URL(string: "https://api.spoonacular.com/recipes/1003464/nutritionWidget.json?apiKey=c4295465101844b6bdb8ae9b78be04ee")!
        
        
        
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
                     // This will run when the network request returns
        if let error = error {
                print(error.localizedDescription)
        } else if let data = data {
            let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
//            print(dataDictionary)
            self.caloriesLabel.text = dataDictionary["calories"] as? String
            self.protein.text = dataDictionary["fat"] as? String
            self.fat.text = dataDictionary["carbs"] as? String
            
        
            self.foodData = dataDictionary["good"] as! [[String : Any]]
            
            
            
          
            self.tableView.reloadData()
            }

            }
                task.resume()
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as! FoodCell
        let foodFacts = foodData[indexPath.row]
        //print(foodFacts["title"])
        
//        cell.category.text =
        cell.calories.text = foodFacts["title"] as? String
        cell.data.text = foodFacts["amount"] as? String
        
        
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
