//
//  PaidOrder+CoreDataProperties.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-11-01.
//
//

import Foundation
import CoreData


extension PaidOrder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PaidOrder> {
        return NSFetchRequest<PaidOrder>(entityName: "PaidOrder")
    }

    @NSManaged public var total: Double
    @NSManaged public var products: Data?
    @NSManaged public var registeredUser: RegisteredUser?

}

extension PaidOrder : Identifiable {

}
