//
//  ItemDetailViewModel.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-11-01.
//

import Foundation
import UIKit

class ItemDetailViewModel {
    let product: Product
    let userID: UUID
    
    init(userID: UUID, product: Product) {
        self.userID = userID
        self.product = product
    }
    
    func productDetailToSaveToCart(appDelegate: AppDelegate) {
        let context = appDelegate.persistentContainer.viewContext
        
        guard let selectedItemId = self.product.id else { return }
        guard let selectedItemName = self.product.title else { return }
        guard let selectedItemPrice = self.product.price else { return}
        guard let selectedItemImage = self.product.image else { return }
        
        var countOfSelectedItemInCart = getCountOfExistingOrder(item: selectedItemName)

        try? self.saveOrderItem(id: selectedItemId, name: selectedItemName, price: selectedItemPrice, image: selectedItemImage, appDelegate: appDelegate)
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func getOrderItemsForLoggedInUser() throws -> [OrderItem] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let registeredUser = try CoreDataService.getRegisteredUser(userID: userID, appDelegate: appDelegate)
        
        guard let userOrderItems = registeredUser.cart?.orderItems else {
            return []
        }
        
        let decodedOrderItems = try JSONDecoder().decode([OrderItem].self, from: userOrderItems)
        return decodedOrderItems
    }
    
    func getCountOfExistingOrder(item: String) -> Int {
        var totalMatchingItemsAlreadyInCart: Int = 0
        let orderedItems = try? self.getOrderItemsForLoggedInUser()
        orderedItems?.forEach({ OrderItem in
            let orderNameInCart = OrderItem.name
            if(orderNameInCart == item) {
                totalMatchingItemsAlreadyInCart += 1
            }
        })
        return totalMatchingItemsAlreadyInCart
    }
    
    func saveOrderItem(id: Int, name: String, price: Double, image: String, appDelegate: AppDelegate) throws {
            let orderItem = OrderItem(id: id, name: name, price: price, image: image )
            let userUUID = userID as UUID
            let registeredUser = try CoreDataService.getRegisteredUser(userID: userUUID, appDelegate: appDelegate)
            
            if let orderItemData = registeredUser.cart?.orderItems {
                var orderItems = try JSONDecoder().decode([OrderItem].self, from: orderItemData)
                orderItems.append(orderItem)
                let data = try JSONEncoder().encode(orderItems)
                registeredUser.cart?.orderItems = data
            } else {
                let data = try JSONEncoder().encode([orderItem])
                registeredUser.cart?.orderItems = data
            }
    }
}
