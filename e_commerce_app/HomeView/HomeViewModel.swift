//
//  HomeViewModel.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-09-13.
//

import CoreData
import UIKit

enum ResponseError: Error {
    case unknownAPIResponse
    case generic
}

final class HomeViewModel {
    let userID: UUID
    var products: [WelcomeElement] = []
    init(userID: UUID) {
        self.userID = userID
    }
    
    func getLoggedInUsername() -> String {
        var loggedInUsername: String = ""
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "RegisteredUser")
        let predicate = NSPredicate(format: "uuid = %@", userID as CVarArg)
        fetch.predicate = predicate
        
        do {
            let result = try context.fetch(fetch)
            print(result)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "username") as! String)
                loggedInUsername = data.value(forKey: "username") as! String
            }
        } catch {
            print("Failed to fetch logged in username with given UUID")
        }
        return loggedInUsername
    }
    
    func getAllProducts(completion: @escaping (Result<[WelcomeElement], Error>) -> Void) {
        
        guard let urlAllProducts = URL(string: "https://fakestoreapi.com/products") else {
            completion(.failure(ResponseError.unknownAPIResponse))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: urlAllProducts)) { data, response, error in

            if let error = error {
                completion(.failure(error))
                return
            }
            // Validation
            guard
                (response as? HTTPURLResponse) != nil,
                let data = data
            else {
                completion(.failure(ResponseError.unknownAPIResponse))
                return
            }
            // convert data to models object
            do {
                guard
                    let resultJson = try JSONDecoder().decode([WelcomeElement]?.self, from: data)
                else {
                    completion(.failure(ResponseError.unknownAPIResponse)) // specificy json dedode error 
                    return
                }
                self.products.insert(contentsOf: resultJson, at: 0)
                
                completion(.success(resultJson))
            }
            catch {
                completion(.failure(error))
                return
            }
        }
        task.resume()
    }
}
