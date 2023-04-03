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
    var userID: UUID? = nil
    var decodedPassword: String? = nil
    
    func getPassword(username: String) throws {
        do {
            guard let data = try KeyChainService.get(username: username) else {
                print("Failed to get data")
                return
            }
            let decodedPassword = String(decoding: data, as: UTF8.self)
            print("read password: \(decodedPassword)")
        } catch {
            print(error)
            throw error
        }
    }
    
    func loginAccountUserID(username: String, decodedPassword: String) throws {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                userID = try CoreDataService.getRegisteredUserUUID(username: username, decodedPassword: decodedPassword, appDelegate: appDelegate)
            }
    }
}
