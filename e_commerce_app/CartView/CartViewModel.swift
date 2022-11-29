//
//  CartViewModel.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-10-25.
//

//import CoreData
import Foundation
import UIKit

class CartViewModel {
    let userID: UUID
    init(userID: UUID) {
        self.userID = userID
    }
    
    func getOrderItemsForLoggedInUser() throws -> [OrderItem] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let registeredUser = try CoreDataService.getRegisteredUser(userID: userID, appDelegate: appDelegate)
        
        guard let userOrderCartItems = registeredUser.cart?.orderItems else {
            return []
        }
        let decodedOrderItems = try JSONDecoder().decode([OrderItem].self, from: userOrderCartItems)
        return decodedOrderItems
    }
    
    func countOfOrderItemForUser() -> Int {
        let countOfOrders: Int = 0
        do {
            let getOrderItems = try self.getOrderItemsForLoggedInUser()
            return getOrderItems.count
        } catch {
            print(error)
        }
        
        return countOfOrders
    }
    
    func getOrderItemsDataForLoggedInUser() throws -> Data? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let registeredUser = try CoreDataService.getRegisteredUser(userID: userID, appDelegate: appDelegate)
        let userOrderItemsData = registeredUser.cart?.orderItems
        return userOrderItemsData
    }
    
    func checkoutCartOrderItemsToPaidOrder() throws {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let registeredUser = try CoreDataService.getRegisteredUser(userID: userID, appDelegate: appDelegate)
        let orderItems = try? self.getOrderItemsDataForLoggedInUser()
        CoreDataService.addPaidOrderForCartCheckoutItem(registeredUser: registeredUser, appDelegate: appDelegate)
        registeredUser.cart?.orderItems = nil
    }
    
    func productDetailToSaveToCart(appDelegate: AppDelegate) throws {
        let context = appDelegate.persistentContainer.viewContext

        try? self.checkoutCartOrderItemsToPaidOrder()
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
}
