//
//  RegisterViewModel.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-09-15.
//

import Foundation
import CoreData
import UIKit

class RegisterViewModel {
    
    func saveRegisteredUser(firstName: String, lastName: String, username: String, password: String) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext

            guard let entityDescription = NSEntityDescription.entity(forEntityName: "RegisteredUser", in: context) else { return }
            let newUser = RegisteredUser(entity: entityDescription,
                                          insertInto: context)
            newUser.firstName = firstName
            newUser.lastName = lastName
            newUser.username = username
            newUser.password = password
            guard let uuid = UUID(uuidString: UUID().uuidString) else {
                preconditionFailure("Unable to create UUID")
            }
            newUser.uuid = uuid
            do {
                try context.save()
                print("Save Successfull")

            } catch let error as NSError{
                print("Saving Error: \(error)")
            }
        }
    }

    func fetchRegisteredUsers() -> [RegisteredUser] {
        let listOfUsernames: [String]
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            do {
                let fetchRequest = NSFetchRequest<RegisteredUser> (entityName: "RegisteredUser")
                let fetchResults = try context.fetch(fetchRequest)
                listOfUsernames = fetchResults.map{ $0.username }
                print(listOfUsernames)
                return fetchResults
            } catch {
                print("Fetching Error: \(error)")
                listOfUsernames = []
            }
        }
        return []
    }
    
     func isUsernameUnique(_ username: String) -> Bool {
        if fetchRegisteredUsers().contains(where: { $0.username == username }) {
            return false
        } else {
            return true
        }
    }
    
}


