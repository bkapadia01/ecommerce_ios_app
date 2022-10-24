//
//  LoginViewModel.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-09-04.
//

import UIKit

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
            userID = try CoreDataService.getRegisteredUserUUID(username: username, password: password, appDelegate: appDelegate)
        }
    }
}
