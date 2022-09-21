//
//  RegisteredUser+CoreDataProperties.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-09-15.
//
//

import Foundation
import CoreData


extension RegisteredUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RegisteredUser> {
        return NSFetchRequest<RegisteredUser>(entityName: "RegisteredUser")
    }

    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    @NSManaged public var password: String
    @NSManaged public var username: String
    @NSManaged public var uuid: UUID

}

extension RegisteredUser : Identifiable {

}
