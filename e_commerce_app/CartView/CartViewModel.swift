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
    var dictionaryIndexPathOfSelectedItem: [IndexPath: Bool] = [:]
    var orderItems: [OrderItem]? = []
    var products: [Product] = []
    let coreDataService: CoreDataService
    
    init(userID: UUID, coreDataService: CoreDataService = CoreDataService()) {
        self.userID = userID
        self.coreDataService = CoreDataService()
    }
    
    func getOrderItemsForLoggedInUser() throws -> [OrderItem] {
        let registeredUser = try coreDataService.getRegisteredUser(userID: userID)
        
        guard let userOrderCartItems = registeredUser.cart?.orderItems else {
            return []
        }
        let decodedOrderItems = try JSONDecoder().decode([OrderItem].self, from: userOrderCartItems)
        return decodedOrderItems
    }
    
    func getOrderItemsDataForLoggedInUser() throws -> Data? {
        let registeredUser = try coreDataService.getRegisteredUser(userID: userID)
        let userOrderItemsData = registeredUser.cart?.orderItems
        return userOrderItemsData
    }
    
    func checkoutCartOrderItemsToPaidOrder() throws {
        let registeredUser = try coreDataService.getRegisteredUser(userID: userID)
        coreDataService.addPaidOrderForCartCheckoutItem(registeredUser: registeredUser)
        registeredUser.cart?.orderItems = nil
    }
    
    func productDetailToSaveToCart() throws {
        let context = coreDataService.persistentContainer.viewContext

        try? self.checkoutCartOrderItemsToPaidOrder()
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func deleteSelectedItemsFromCart() {
        
        do {
            let registeredUser = try coreDataService.getRegisteredUser(userID: self.userID)
            for (indexPath, shouldDelete) in dictionaryIndexPathOfSelectedItem {
                if shouldDelete {
                    orderItems?.remove(at: indexPath.item)
                }
            }

            registeredUser.cart?.orderItems = try JSONEncoder().encode(orderItems)
            coreDataService.saveContext()
            dictionaryIndexPathOfSelectedItem.removeAll()
        } catch {
            print(error)
        }
    }
    
    func getCartProductInfo(at indexPath: IndexPath) -> ProductRenderableInfo {
        let orderItemAtIndexPath = self.orderItems?[indexPath.item]
        guard let orderItemImageURL = orderItemAtIndexPath?.image,
              let url = URL(string: orderItemImageURL),
              let data = try? Data(contentsOf: url),
              let productImage = UIImage(data: data)
        else {
            guard let missingImage = UIImage(named: Constants.FileName.missingImage) else {
                preconditionFailure()
            }
            return ProductRenderableInfo(image: missingImage, productTitle: orderItemAtIndexPath?.name ?? AppLocalizable.missingName.localized())
        }
        return ProductRenderableInfo(image: productImage, productTitle: orderItemAtIndexPath?.name ?? AppLocalizable.missingName.localized())
    }
}
