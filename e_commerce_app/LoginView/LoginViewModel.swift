//
//  LoginViewModel.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-09-04.
//

import UIKit
import Security

enum KeychainError: Error {
    case itemNotFound
    case failedToAddItem(status: OSStatus)
    case failedToUpdateItem(status: OSStatus)
    case unexpectedError(status: OSStatus)
}

final class LoginViewModel {
    
    let coreDataService: CoreDataService
    
    init(coreDataService: CoreDataService = CoreDataService()) {
        self.coreDataService = coreDataService
    }
    
    var userID: UUID? = nil
    
    func validateCredentialUsingKeychain(username: String, password: String)  throws  {
        let service = "e-commerce app"

        guard !username.isEmpty || !password.isEmpty else {
            throw ValidationError.missingUsernamePassword.nsError
        }
        guard !username.isEmpty else {
            throw ValidationError.missingUsername.nsError
        }
        guard !password.isEmpty else {
            throw ValidationError.missingPassword.nsError
        }

        let account = username
        let passwordData = password.data(using: .utf8)!
        
        // Set up a Keychain query dictionary to use for all Keychain operations
        var query: [String: Any] = [:]
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service
        query[kSecAttrAccount as String] = account
        
        // Check if a password already exists in Keychain for the given username
          var status = SecItemCopyMatching(query as CFDictionary, nil)
          switch status {
          case errSecSuccess:
              // If a password already exists, update it with the new one
              var attributesToUpdate: [String: Any] = [:]
              attributesToUpdate[kSecValueData as String] = passwordData
              status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
              if status != errSecSuccess {
                  throw KeychainError.failedToUpdateItem(status: status)
              }
          case errSecItemNotFound:
              // If a password doesn't exist, create a new Keychain item for the user
              query[kSecValueData as String] = passwordData
              status = SecItemAdd(query as CFDictionary, nil)
              if status != errSecSuccess {
                  throw KeychainError.failedToAddItem(status: status)
              }
          default:
              print("Error: \(status)")
              throw KeychainError.unexpectedError(status: status)
          }
        
         userID = try coreDataService.getRegisteredUserUUID(username: username, password: password)
    }
    
    
}
