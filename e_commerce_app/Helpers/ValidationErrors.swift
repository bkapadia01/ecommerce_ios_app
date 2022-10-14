//
//  ValidationErrors.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-10-01.
//

import Foundation
import UIKit

enum ValidationError: Error {
    case missingUsernamePassword
    case missingUsername
    case missingPassword
    case invalidCredentials
    case registrationFieldsIncomplete
    case usernameLengthTooShort
    case passwordLengthTooShort
    case passwordsDoNotMatch
    case usernameAlreadyExists

    var nsError: NSError {
        return NSError(domain: "", code: code, userInfo: [NSLocalizedDescriptionKey:errorDescription])
    }
    
    var code: Int {
        switch self {
        case .missingUsernamePassword: return 0
        case .missingUsername: return 1
        case .missingPassword: return 2
        case .invalidCredentials: return 3
        case .registrationFieldsIncomplete: return 4
        case .usernameLengthTooShort: return 5
        case .passwordLengthTooShort: return 6
        case .passwordsDoNotMatch: return 7
        case .usernameAlreadyExists: return 8
        }
    }
    
    var errorDescription: String {
        switch self {
        case .missingUsernamePassword:
            return NSLocalizedString("No username/password entered", comment: "Missing both username and password fields")
        case .missingUsername:
            return NSLocalizedString("No username entered", comment: "Missing username field")
        case .missingPassword:
            return NSLocalizedString("No password entered", comment: "Missing password field")
        case .invalidCredentials:
            return NSLocalizedString("Invalid credentials. Try again.", comment: "Username / password do not match any registered users")
        case .registrationFieldsIncomplete:
            return NSLocalizedString("Please complete all fields.", comment: "Not all registration fields are compelted")
        case .usernameLengthTooShort:
            return NSLocalizedString("Username must greater than 4 chars.", comment: "Username is not long enough")
        case .passwordLengthTooShort:
            return NSLocalizedString("Password must greater than 4 chars.", comment: "Password is not long enough")
        case .passwordsDoNotMatch:
            return NSLocalizedString("The passwords do not match.", comment: "The 2 entered passwords do not match")
        case .usernameAlreadyExists:
            return NSLocalizedString("Username already exists. Try another one or login instead.", comment: "Username already exits in the db")
        }
    }
}
