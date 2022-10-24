//
//  HomeViewModel.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-09-13.
//

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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let loggedInUsername = CoreDataService.getLoggedInUsernameForUuid(userID: userID, appDelegate: appDelegate)
        
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
