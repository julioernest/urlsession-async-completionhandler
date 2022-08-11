//
//  ViewController.swift
//  Await
//
//  Created by Julio-Ernest Costache on 11.08.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView1: UITableView!
    @IBOutlet var tableView2: UITableView!
    let network = Network()
    let url = "https://random-data-api.com/api/food/random_food"
 
    var foodDetails: [String]?
    var asyncFoodDetails: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        network.getRandomFoodWithCompletionHandles(url: url) { [weak self] result in
            switch result {
            case .success(let resultFood):
                self?.foodDetails = [
                    resultFood.dish,
                    resultFood.ingredient,
                    resultFood.description
                ]
                DispatchQueue.main.async {
                    self?.tableView1.reloadData()
                }
                
                
            case .failure(let error):
                print(error)
            }
        }
        Task {
            do {
                let food = try await network.getRandomFood(url: url)
                asyncFoodDetails = [
                    food.dish,
                    food.ingredient,
                    food.description
                ]
                DispatchQueue.main.async {
                    self.tableView2.reloadData()
                }
            }
            catch {
                print(error)
            }
        }
        
        
    }

}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case tableView1:
            return foodDetails?.count ?? 0
        case tableView2:
            return asyncFoodDetails?.count ?? 0
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView{
        case tableView1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = foodDetails?[indexPath.row]
            return cell
        case tableView2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
            cell.textLabel?.text = asyncFoodDetails?[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    
}

