//
//  ProfileViewModel.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-11-10.
//

import Foundation
import UIKit
import CloudKit

class ProfileViewModel {
    
    let userID: UUID
    init(userID: UUID) {
        self.userID = userID
    }
    
    func getRegisteredUser(appDelegate: AppDelegate) throws -> RegisteredUser {
        
        let getRegisteredUser = try CoreDataService.getRegisteredUser(userID: userID, appDelegate: appDelegate)
        return getRegisteredUser
    }
    
    func getPaidOrderItems() throws -> [PaidOrder] {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let registeredUser = try CoreDataService.getRegisteredUser(userID: userID, appDelegate: appDelegate)
        let userOrderPaidItems = try CoreDataService.getPaidOrdersForUser(registeredUser: registeredUser, appDelegate: appDelegate)
        return userOrderPaidItems
    }
    
    func getCountOfPaidOrders() -> Int {
        
        do {
            let paidOrders = try self.getPaidOrderItems()
            return paidOrders.count
        } catch {
            print(error)
        }
        return 0
    }
    
    func getPaidOrderAtIndexPath(indexPath: IndexPath) -> PaidOrder? {
        
        do {
            let paidOrders = try self.getPaidOrderItems()
            return paidOrders[indexPath.row]
        } catch {
            print(error)
        }
        return nil
    }
    
    func getTotalPaidOrderAtIndexPath(indexPath: IndexPath) -> Double {
        
        do {
            let paidOrders = try self.getPaidOrderItems()
            guard let paidOrderAtIndexPath = paidOrders[indexPath.row].orderItems else {
                return 0
            }
            let orderItems = try JSONDecoder().decode([OrderItem].self, from: paidOrderAtIndexPath)
            var total: Double = 0.0
            orderItems.forEach { order in
                total += order.price
            }
            return total
        } catch {
            print(error)
        }
        return 0
    }
}
