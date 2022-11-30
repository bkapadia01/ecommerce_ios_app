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
    
    func getOrderItemsDataForLoggedInUser() throws -> Data? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let registeredUser = try CoreDataService.getRegisteredUser(userID: userID, appDelegate: appDelegate)
        let userOrderItemsData = registeredUser.cart?.orderItems
        return userOrderItemsData
    }
    
    func checkoutCartOrderItemsToPaidOrder() throws {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let registeredUser = try CoreDataService.getRegisteredUser(userID: userID, appDelegate: appDelegate)
        CoreDataService.addPaidOrderForCartCheckoutItem(registeredUser: registeredUser, appDelegate: appDelegate)
        registeredUser.cart?.orderItems = nil
    }
    
    func productDetailToSaveToCart(appDelegate: AppDelegate) throws {
        let context = appDelegate.persistentContainer.viewContext

        try? self.checkoutCartOrderItemsToPaidOrder()
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func deleteSelectedItemsFromCart(appDelegate: AppDelegate) {
        
        do {
            let registeredUser = try CoreDataService.getRegisteredUser(userID: self.userID, appDelegate: appDelegate)
            for (indexPath, shouldDelete) in dictionaryIndexPathOfSelectedItem {
                if shouldDelete {
                    orderItems?.remove(at: indexPath.item)
                }
            }

            registeredUser.cart?.orderItems = try JSONEncoder().encode(orderItems)
            appDelegate.saveContext()
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
