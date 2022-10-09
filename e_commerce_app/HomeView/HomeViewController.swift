//
//  HomeViewController.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-09-04.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeWelcomeLabel: UILabel!
    
    private let homeViewModel: HomeViewModel
    
    init?(homeViewModel: HomeViewModel, coder: NSCoder) {
        self.homeViewModel = homeViewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeWelcomeLabel.text = "Welcome \(homeViewModel.getLoggedInUsername())"
        getAllProducts()
    }
    
    func getAllProducts() {
        let url = "https://fakestoreapi.com/products"
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {
            data, response, error in
            
            // Validation
            guard let data = data, error == nil else {
                print("Unable to get data from API")
                return
            }
            
            // convert data to models object
            var json: WelcomeElement?
            do {
                json = try JSONDecoder().decode(WelcomeElement.self, from: data)
            } catch {
                print("Error: \(error)")
            }

            guard let results = json else {
                return
            }
            
            print(results)
        })
        task.resume()
        
    }
    
}
