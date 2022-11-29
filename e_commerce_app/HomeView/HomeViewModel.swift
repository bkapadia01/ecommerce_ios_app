//
//  HomeViewModel.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-09-13.
//

import UIKit
struct ProductRenderableInfo {
    let image: UIImage
    let productTitle: String
}

enum ResponseError: Error {
    case unknownAPIResponse
    case generic
}

final class HomeViewModel {
    var products: [Product] = []
    
    let userID: UUID
    init(userID: UUID) {
        self.userID = userID
    }
    
    func getProductInfo(at indexPath: IndexPath) -> ProductRenderableInfo {
        let productAtIndexPath = products[indexPath.item]
        guard let productImageURL = productAtIndexPath.image,
              let url = URL(string: productImageURL),
              let data = try? Data(contentsOf: url),
              let productImage = UIImage(data: data)
        else {
            guard let missingImage = UIImage(named: "missing_image") else {
                preconditionFailure()  // crash app for missing image(local)
            }
            return ProductRenderableInfo(image: missingImage, productTitle: productAtIndexPath.title ?? "Missing Title")
        }
        return ProductRenderableInfo(image: productImage, productTitle: productAtIndexPath.title ?? "Missing Title")
    }
    
    func getLoggedInUsername() -> String {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let loggedInUsername = CoreDataService.getLoggedInUsernameForUuid(userID: userID, appDelegate: appDelegate)
        
        return loggedInUsername
    }
    
    func getAllProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        
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
                    let resultJson = try JSONDecoder().decode([Product]?.self, from: data)
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
