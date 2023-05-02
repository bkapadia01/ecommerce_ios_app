//
//  LoginViewModel.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-09-04.
//

import UIKit
import Security

final class LoginViewModel {
    
    var userID: UUID? = nil

    func checkLoginCredentials(username: String, password: String) throws {
        guard !username.isEmpty || !password.isEmpty else {
            throw ValidationError.missingUsernamePassword.nsError
        }
        guard !username.isEmpty else {
            throw ValidationError.missingUsername.nsError
        }
        guard !password.isEmpty else {
            throw ValidationError.missingPassword.nsError
        }
        
        do {
            try KeyChainService.validatePasswordForUsername(username: username) 
        } catch {
            print(error)
            throw error
        }
    }
    
    func loginAccountUserID(username: String) throws {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            userID = try CoreDataService.getRegisteredUserUUID(username: username, appDelegate: appDelegate)
        }
    }
}
