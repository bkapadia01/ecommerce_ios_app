//
//  RegisterViewModel.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-09-15.
//

import UIKit

class RegisterViewModel {
    
    func saveRegisteredUser(firstName: String, lastName: String, username: String, password: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            preconditionFailure()
        }
        
        CoreDataService.saveRegisteringUser(firstName: firstName, lastName: lastName, username: username, appDelegate: appDelegate)
    }
    
    func isUsernameUnique(_ username: String) -> Bool {
        guard let  appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            preconditionFailure()
        }
        
        let usernames = CoreDataService.getRegistredUsernames(appDelegate: appDelegate)
        if usernames.contains(where: { $0 == username }) {
            return false
        }
        return true
    }
    
    // return error string if validation is incorrect else throw error
    func validateRegistrationFields(firstName: String, lastName: String, username: String, password: String, repeatedPassword: String) throws {
        do {
            guard !firstName.isEmpty &&
                    !lastName.isEmpty &&
                    !username.isEmpty &&
                    !password.isEmpty &&
                    !repeatedPassword.isEmpty else {
                throw ValidationError.registrationFieldsIncomplete.nsError
            }
            
            guard username.count > 4 else {
                throw ValidationError.usernameLengthTooShort.nsError
            }
            
            guard password.count > 4 else {
                throw ValidationError.passwordLengthTooShort.nsError
            }
            
//            guard password == repeatedPassword else {
//                throw ValidationError.passwordsDoNotMatch.nsError
//            }
//
            guard self.isUsernameUnique(username) == true else {
                throw ValidationError.usernameAlreadyExists.nsError
            }
            try KeyChainService.save(username: username, password: password)
        }
    }
}
