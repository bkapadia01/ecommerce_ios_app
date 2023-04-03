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
        let keychainAccessGroupName = "com.bkap.e-commerce-app"
        let account: String = username
        let passwordData: Data = password.data(using: .utf8) ?? Data()

        var query: [String: AnyObject] = [:]
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject
        query[kSecAttrAccount as String] = account as AnyObject
        query[kSecValueData as String] = passwordData as AnyObject
//        query[kSecAttrAccessGroup as String] = "com.bkap.e-commerce-app" as AnyObject

        let status = SecItemAdd(query as CFDictionary, nil)
        print("Save")
        
        guard status == errSecDuplicateItem else {
            print("duplicate entry, status: \(status)")
            throw KeychainError.duplicateEntry
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
        
    }
    
    static func get(username: String) throws -> Data? {
        let service: String = "e-commerceapp.com"
        let keychainAccessGroupName = "AB123CDE45.myKeychainGroup1"
        let account: String = username

        var query: [String: AnyObject] = [:]
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject
        query[kSecAttrAccount as String] = account as AnyObject
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecAttrAccessGroup as String] = keychainAccessGroupName as AnyObject

        var result: AnyObject?
        var status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess else {
            print("status:\(status)")
            throw KeychainError.unknown(status)
        }
        print("read status: \(status)")
        return result as! Data?
        
    }
}
