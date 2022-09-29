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
    
    private let homeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        viewModel.getLoggedInUser()
        //        setupBinder()
    }
    
    private func setupBinder() {
        //        viewModel.welcomeMessage.bind{ [weak self] message in
        //            self?.homeWelcomeLabel.text = message
        //            self?.save(value: )
        //            self?.retrieveValues()
    }
}

