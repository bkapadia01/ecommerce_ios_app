//
//  CoreDataService.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-10-18.
//

import CoreData

enum CoreDataService {
    static func getRegisteredUserUUID(username: String, password: String, appDelegate: AppDelegate) throws -> UUID {
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<RegisteredUser> (entityName: "RegisteredUser")
        let predicate = NSPredicate(format: "username == %@", username)
        fetchRequest.predicate = predicate
        do {
            guard let registeredUser = try context.fetch(fetchRequest).first else {
                print("Username does not exists in database")
                throw ValidationError.invalidCredentials.nsError
            }
            print("user found:\n \(registeredUser)")
            if registeredUser.password != password {
                print("passwords does not match exiting user in database")
                throw ValidationError.invalidCredentials.nsError
            }
            return registeredUser.uuid
        }
    }
    
    
    static func getRegistredUsernames(appDelegate: AppDelegate) -> [String] {
        
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let fetchRequest = NSFetchRequest<RegisteredUser> (entityName: "RegisteredUser")
            let fetchResults = try context.fetch(fetchRequest)
            return fetchResults.map{ $0.username }
        } catch {
            print("Fetching Error: \(error)")
            return []
        }
    }
    
}
