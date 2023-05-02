//
//  ProfileViewModel.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-11-10.
//

import Foundation
import CloudKit

struct UserRenderableInfo {
    let firstName: String
    let lastName: String
    let userName: String
}

class ProfileViewModel {
    
    let userID: UUID
    let coreDataService: CoreDataService
    init(userID: UUID, coreDataService: CoreDataService = CoreDataService()) {
        self.userID = userID
        self.coreDataService = coreDataService
    }

    func getRegisteredUser() throws -> RegisteredUser {
        let getRegisteredUser = try coreDataService.getRegisteredUser(userID: userID)
        return getRegisteredUser
    }
    
    func getUserProfileInfo() -> UserRenderableInfo {
        let currentRegisteredUser = try? self.getRegisteredUser()
        return UserRenderableInfo(firstName: currentRegisteredUser?.firstName ?? "", lastName: currentRegisteredUser?.lastName ?? "", userName: currentRegisteredUser?.username ?? "")
    }
    
    func getPaidOrderItems() throws -> [PaidOrder] {
        let registeredUser = try coreDataService.getRegisteredUser(userID: userID)
        let userOrderPaidItems = try coreDataService.getPaidOrdersForUser(registeredUser: registeredUser)
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
                return 0.0
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
        return 0.0
    }
}
