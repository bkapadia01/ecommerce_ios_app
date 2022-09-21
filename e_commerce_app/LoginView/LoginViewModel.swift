//
//  LoginViewModel.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-09-04.
//

import Foundation
import UIKit
import CoreData

final class LoginViewModel {
    
    var error: ObservableObject<String?> = ObservableObject(nil)
    
    func login(username: String, password: String) {
//        fetchRegisteredUser(username: username)
        
//        NetworkService.shared.login(emailAdress: email, password: password) { [weak self] success in
//            self?.error.value = success ? nil : "Invalid Creds"
//        }
    }
    
    func fetchRegisteredUser(username: String) -> RegisteredUser? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<RegisteredUser> (entityName: "RegisteredUser")
            let predicate = NSPredicate(format: "username == %@", username)
            fetchRequest.predicate = predicate
            do {
                guard let registeredUser = try context.fetch(fetchRequest).first else {
                    print("Username does not exists")
                    return nil
                }
                print("user found:\n \(registeredUser)")
                return registeredUser
            } catch let error as NSError{
                print("Fetching Error: \(error)")
            }
        }
        return nil
    }
    
    func validatePasswordForRegisteredUser(registeredUser: RegisteredUser, password: String) -> Bool {
        print(">>>>>><<<<<<")
        print(registeredUser.password)
        print(password)
        
        if registeredUser.password == password {
            return true
        } else {
            return false
        }
        
    }

}

