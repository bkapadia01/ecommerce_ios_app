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
    
    static func saveRegisteringUser(firstName: String, lastName: String, username: String, password: String, appDelegate: AppDelegate) {
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
    
    static func getLoggedInUsernameForUuid(userID: UUID, appDelegate: AppDelegate) -> String {
        var loggedInUsername: String = ""

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
