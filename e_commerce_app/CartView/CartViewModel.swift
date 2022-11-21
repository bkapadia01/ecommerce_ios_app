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
        
        guard let userOrderItems = registeredUser.cart?.orderItems else {
            return []
        }
        let decodedOrderItems = try JSONDecoder().decode([OrderItem].self, from: userOrderItems)
//        print(decodedOrderItems)
        return decodedOrderItems
    }
    
    func getOrderItemsDataForLoggedInUser() throws -> Data? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let registeredUser = try CoreDataService.getRegisteredUser(userID: userID, appDelegate: appDelegate)
        let userOrderItemsData = registeredUser.cart?.orderItems

       
        return userOrderItemsData
    }
    
    
    
    func checkoutCartOrderItemsToPaidOrder() throws {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let registeredUser = try CoreDataService.getRegisteredUser(userID: userID, appDelegate: appDelegate)
        let orderItems = try? self.getOrderItemsDataForLoggedInUser()
        
        if registeredUser.paidOrder == nil {
            registeredUser.paidOrder = [orderItems as Any]
        } else {
            registeredUser.paidOrder = [1, orderItems]
        }
        
//        if let orderItemData = registeredUser.paidOrder?.orderItems {
//        } else {
//            registeredUser.paidOrder?.orderItems = orderItems
//        }
        
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
