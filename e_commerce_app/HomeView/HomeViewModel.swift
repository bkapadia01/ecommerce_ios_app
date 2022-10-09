//
//  HomeViewModel.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-09-13.
//

import CoreData
import UIKit

final class HomeViewModel {
    let userID: UUID
    
    init(userID: UUID) {
        self.userID = userID
    }
    
    func getLoggedInUsername() -> String {
        var loggedInUsername: String = ""
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "RegisteredUser")
        let predicate = NSPredicate(format: "uuid = %@", userID as CVarArg)
        fetch.predicate = predicate
        
        do {
            let result = try context.fetch(fetch)
            print(result)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "username") as! String)
                loggedInUsername = data.value(forKey: "username") as! String
            }
        } catch {
            print("Failed to fetch logged in username with given UUID")
        }
        return loggedInUsername

    }
}
