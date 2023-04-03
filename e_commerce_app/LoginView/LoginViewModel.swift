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

    
    func getPassword(username: String) throws {
        do {
            guard let data = try KeyChainService.get(username: username) else {
                print("Failed to get data")
                return
            }
            let password = String(decoding: data, as: UTF8.self)
            print("read password: \(password)")
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                userID = try CoreDataService.getRegisteredUserUUID(username: username, appDelegate: appDelegate)
            }
        } catch {
            print(error)
            throw error
        }
    }
}
