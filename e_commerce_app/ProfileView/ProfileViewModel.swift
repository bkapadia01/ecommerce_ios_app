//
//  ProfileViewModel.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-11-10.
//

import Foundation

class ProfileViewModel {
    
    let userID: UUID
    init(userID: UUID) {
        self.userID = userID
    }
    
    func getRegisteredUser(appDelegate: AppDelegate) throws -> RegisteredUser {

        let getRegisteredUser = try CoreDataService.getRegisteredUser(userID: userID, appDelegate: appDelegate)
        return getRegisteredUser
    }
}
