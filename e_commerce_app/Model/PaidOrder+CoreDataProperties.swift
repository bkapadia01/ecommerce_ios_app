//
//  PaidOrder+CoreDataProperties.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-10-25.
//
//

import Foundation
import CoreData


extension PaidOrder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PaidOrder> {
        return NSFetchRequest<PaidOrder>(entityName: "PaidOrder")
    }

    @NSManaged public var billTotal: Double

}

extension PaidOrder : Identifiable {

}
