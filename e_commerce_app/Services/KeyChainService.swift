//
//  KeyChainService.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2023-04-02.
//

import Foundation

class KeyChainService {
    
    enum KeychainError: Error {
        case duplicateEntry
        case unknown(OSStatus)
    }
    
    static func save(username: String, password: String) throws {
        let service: String = "e-commerceapp.com"
        let account: String = username
        let passwordData: Data = password.data(using: .utf8)!

        var query: [String: AnyObject] = [:]
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject
        query[kSecAttrAccount as String] = account as AnyObject
        query[kSecValueData as String] = passwordData as AnyObject

        let status = SecItemAdd(query as CFDictionary, nil)
        print("Save")
        
        guard status != errSecDuplicateItem else {
            print("duplicate entry, status: \(status)")
            throw KeychainError.duplicateEntry
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
        
    }
    
    static func validatePasswordForUsername(username: String) throws {
        let service: String = "e-commerceapp.com"
        let account: String = username

        var query: [String: AnyObject] = [:]
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject
        query[kSecAttrAccount as String] = account as AnyObject
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var result: CFTypeRef? // CFTypeRef type is the base type defined in Core Foundatio
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess else {
            print("status:\(status)")
            throw ValidationError.invalidCredentials.nsError
        }
    }
}
