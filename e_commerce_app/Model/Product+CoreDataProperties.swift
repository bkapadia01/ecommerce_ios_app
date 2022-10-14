//
//  Product+CoreDataProperties.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-09-29.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var image: String?
    @NSManaged public var category: String?
    @NSManaged public var itemDescription: String?

}

extension Product : Identifiable {

}
