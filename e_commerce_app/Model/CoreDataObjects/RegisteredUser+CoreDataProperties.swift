//
//  RegisteredUser+CoreDataProperties.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-11-01.
//
//

import Foundation
import CoreData


extension RegisteredUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RegisteredUser> {
        return NSFetchRequest<RegisteredUser>(entityName: "RegisteredUser")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var password: String?
    @NSManaged public var username: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var cart: Cart?
    @NSManaged public var paidOrders: [PaidOrder]?

}

// MARK: Generated accessors for paidOrder
extension RegisteredUser {

    @objc(addPaidOrderObject:)
    @NSManaged public func addToPaidOrder(_ value: PaidOrder)

    @objc(removePaidOrderObject:)
    @NSManaged public func removeFromPaidOrder(_ value: PaidOrder)

    @objc(addPaidOrder:)
    @NSManaged public func addToPaidOrder(_ values: NSSet)

    @objc(removePaidOrder:)
    @NSManaged public func removeFromPaidOrder(_ values: NSSet)

}

extension RegisteredUser : Identifiable {

}
