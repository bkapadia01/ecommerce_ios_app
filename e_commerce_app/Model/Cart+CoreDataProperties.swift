//
//  Cart+CoreDataProperties.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-09-29.
//
//

import Foundation
import CoreData


extension Cart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cart> {
        return NSFetchRequest<Cart>(entityName: "Cart")
    }

    @NSManaged public var userId: UUID?
    @NSManaged public var count: Int16
    @NSManaged public var orderStatus: Int16
    @NSManaged public var products: NSSet?

}

// MARK: Generated accessors for products
extension Cart {

    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: Product)

    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: Product)

    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)

    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)

}

extension Cart : Identifiable {

}
