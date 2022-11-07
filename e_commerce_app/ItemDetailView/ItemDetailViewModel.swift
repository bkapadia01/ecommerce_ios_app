//
//  ItemDetailViewModel.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-11-01.
//
import CoreData
import Foundation

class ItemDetailViewModel {
    let product: Product
    let userID: UUID
    var managedObjectContext: NSManagedObjectContext?

    init(userID: UUID, product: Product) {
        self.userID = userID
        self.product = product
    }
    
    func productDetailToSaveToCart(appDelegate: AppDelegate) {
        let context = appDelegate.persistentContainer.viewContext
        
        guard let selectedItemId = self.product.id else { return }
        guard let selectedItemName = self.product.title else { return }
        guard let selectedItemPrice = self.product.price else { return}
        let selectedItemQuantity = 1
        try? self.saveProduct(id: selectedItemId, name: selectedItemName, price: selectedItemPrice, quantity: selectedItemQuantity , appDelegate: appDelegate)
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func saveProduct(id: Int, name: String, price: Double, quantity: Int, appDelegate: AppDelegate) throws {
        
        let products = [OrderItem(id: id, name: name, price: price, quantity: quantity)]
        let data = try JSONEncoder().encode(products)
        let userUUID = userID as UUID
        let registeredUser = try self.getRegisteredUser(userID: userUUID, appDelegate: appDelegate)
        let cart = Cart(entity: NSEntityDescription.entity(forEntityName: "Cart", in: appDelegate.persistentContainer.viewContext)!, insertInto: appDelegate.persistentContainer.viewContext)
        cart.products = data
        cart.registeredUser = registeredUser
    }
    

    func getRegisteredUser(userID: UUID, appDelegate: AppDelegate) throws -> RegisteredUser {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<RegisteredUser> (entityName: "RegisteredUser")
        let predicate = NSPredicate(format: "uuid == %@", userID as CVarArg)
        fetchRequest.predicate = predicate
        do {
            guard let registeredUser = try context.fetch(fetchRequest).first else {
                print("Username does not exists in database")
                throw ValidationError.invalidCredentials.nsError
            }
            print("user found:\n \(registeredUser)")
            return registeredUser
        }
    }
}
