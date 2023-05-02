//
//  CoreDataService.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-10-18.
//

import CoreData

class CoreDataService {
    
    lazy var persistentContainer: NSPersistentContainer = {
           /*
            The persistent container for the application. This implementation
            creates and returns a container, having loaded the store for the
            application to it. This property is optional since there are legitimate
            error conditions that could cause the creation of the store to fail.
           */
           let container = NSPersistentContainer(name: "UsersModel")
           container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               if let error = error as NSError? {
                   // Replace this implementation with code to handle the error appropriately.
                   // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
   
                   /*
                    Typical reasons for an error here include:
                    * The parent directory does not exist, cannot be created, or disallows writing.
                    * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                    * The device is out of space.
                    * The store could not be migrated to the current model version.
                    Check the error message to determine what the actual problem was.
                    */
                   fatalError("Unresolved error \(error), \(error.userInfo)")
               }
           })
           return container
       }()

       // MARK: - Core Data Saving support

       func saveContext () {
           let context = persistentContainer.viewContext
           if context.hasChanges {
               do {
                   try context.save()
               } catch {
                   // Replace this implementation with code to handle the error appropriately.
                   // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                   let nserror = error as NSError
                   fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
               }
           }
       }
        
    func getRegisteredUserUUID(username: String, password: String) throws -> UUID {
        
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<RegisteredUser> (entityName: "RegisteredUser")
        let predicate = NSPredicate(format: "username == %@", username)
        fetchRequest.predicate = predicate
        do {
            guard let registeredUser = try context.fetch(fetchRequest).first else {
                print("Username does not exists in database")
                throw ValidationError.invalidCredentials.nsError
            }
           
            return registeredUser.uuid!
        }
    }
    
    
    func getRegistredUsernames() -> [String] {
        
        let context = persistentContainer.viewContext
        
        do {
            let fetchRequest = NSFetchRequest<RegisteredUser> (entityName: "RegisteredUser")
            let fetchResults = try context.fetch(fetchRequest)
            return fetchResults.map{ $0.username! }
        } catch {
            print("Fetching Error: \(error)")
            return []
        }
    }
    
     func saveRegisteringUser(firstName: String, lastName: String, username: String, password: String) {
        let context = persistentContainer.viewContext
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "RegisteredUser", in: context) else { return }
        let newUser = RegisteredUser(entity: entityDescription,
                                     insertInto: context)
        newUser.firstName = firstName
        newUser.lastName = lastName
        newUser.username = username
        guard let uuid = UUID(uuidString: UUID().uuidString) else {
            preconditionFailure("Unable to create UUID")
        }
        newUser.uuid = uuid
        newUser.cart = createCartForNewUser()
        do {
            try context.save()
            print("Save Successfull")
            
        } catch let error as NSError{
            print("Saving Error: \(error)")
        }
    }
    
    func createCartForNewUser() -> Cart {
        return Cart(entity: NSEntityDescription.entity(forEntityName: "Cart", in: persistentContainer.viewContext)!, insertInto: persistentContainer.viewContext)
    }
    
    func getLoggedInUsernameForUuid(userID: UUID) -> String {
        var loggedInUsername: String = ""

        let context = persistentContainer.viewContext
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
            print("Failed to fetch logged in username with given UUID - \(error)")
        }
        return loggedInUsername
    }
    
    func getRegisteredUser(userID: UUID) throws -> RegisteredUser {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<RegisteredUser> (entityName: "RegisteredUser")
        let predicate = NSPredicate(format: "uuid == %@", userID as CVarArg)
        fetchRequest.predicate = predicate
        do {
            guard let registeredUser = try context.fetch(fetchRequest).first else {
                print("Username does not exists in database")
                throw ValidationError.invalidCredentials.nsError
            }
            return registeredUser
        }
    }
    
    func addPaidOrderForCartCheckoutItem(registeredUser: RegisteredUser) {
        let context = persistentContainer.viewContext
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "PaidOrder", in: context) else { return }
        let paidOrderData = PaidOrder(entity: entityDescription, insertInto: context)
        paidOrderData.registeredUser = registeredUser
        paidOrderData.orderItems = registeredUser.cart?.orderItems
        paidOrderData.paidDate = Date()
        do {
            try context.save()
        } catch {
            print("Failed saving - \(error)")
        }
    }
    
    func getPaidOrdersForUser(registeredUser: RegisteredUser) throws -> [PaidOrder] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<PaidOrder> (entityName: "PaidOrder")
        
        let predicate = NSPredicate(format: "registeredUser == %@", registeredUser)
        fetchRequest.predicate = predicate
       
        let paidOrders = try context.fetch(fetchRequest)
        return paidOrders
    }
}
