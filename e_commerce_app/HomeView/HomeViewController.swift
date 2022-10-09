//
//  HomeViewController.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-09-04.
//

import Foundation
import UIKit
import CoreData

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
    }
    
}

