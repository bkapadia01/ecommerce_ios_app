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
    
    private let viewModel = HomeViewModel()
    
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
    


extension HomeViewController {
    func save(value: String) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "UsersEntity", in: context) else { return }
            let newValue = NSManagedObject(entity: entityDescription, insertInto: context)
            newValue.setValue(value, forKey: "testValue")
            do {
                try context.save()
                print("Saved: \(value)")
            } catch {
                print("Saving Error")
            }
        }
    }
//
//    func retrieveValues() {
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//            let context = appDelegate.persistentContainer.viewContext
//            let fetchRequest = NSFetchRequest<RegisteredUser>(entityName: "RegisteredUser")
//
//            do {
//                let results = try context.fetch(fetchRequest)
//
//                for result in results {
//                    if let testValue = result.testValue {
//                        print(testValue)
//                    }
//                }
//            } catch {
//                print("Could not retreive values")
//            }
//        }
//    }
}
