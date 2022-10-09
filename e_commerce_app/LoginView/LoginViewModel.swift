//
//  LoginViewModel.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-09-04.
//

import UIKit
import CoreData

final class LoginViewModel {
    var userID: UUID? = nil
    
    func validateCredentials(username: String, password: String) throws {
        
        guard !username.isEmpty || !password.isEmpty else {
            throw ValidationError.missingUsernamePassword.nsError
        }
        guard !username.isEmpty else {
            throw ValidationError.missingUsername.nsError
        }
        guard !password.isEmpty else {
            throw ValidationError.missingPassword.nsError
        }
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<RegisteredUser> (entityName: "RegisteredUser")
            let predicate = NSPredicate(format: "username == %@", username)
            fetchRequest.predicate = predicate
            do {
                guard let registeredUser = try context.fetch(fetchRequest).first else {
                    print("Username does not exists in database")
                    throw ValidationError.invalidCredentials.nsError
                }
                print("user found:\n \(registeredUser)")
                if registeredUser.password != password {
                    print("passwords does not match exiting user in database")
                    throw ValidationError.invalidCredentials.nsError
                }
                userID = registeredUser.uuid
            } 
        }
    }
}
