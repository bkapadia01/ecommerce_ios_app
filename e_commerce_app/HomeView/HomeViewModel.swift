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
    var productItems: [Product] = []
    let userID: UUID
    let coreDataService: CoreDataService
    
    init(userID: UUID, coreDataService:CoreDataService = CoreDataService()) {
        self.userID = userID
        self.coreDataService = coreDataService
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
            return ProductRenderableInfo(image: missingImage, productTitle: productAtIndexPath.title ?? AppLocalizable.missingTitle.localized())
        }
        return ProductRenderableInfo(image: productImage, productTitle: productAtIndexPath.title ?? AppLocalizable.missingTitle.localized())
    }
    
    func getLoggedInUsername() -> String {
        let loggedInUsername = coreDataService.getLoggedInUsernameForUuid(userID: userID)
        
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
            guard
                (response as? HTTPURLResponse) != nil,
                let data = data
            else {
                completion(.failure(ResponseError.unknownAPIResponse))
                return
            }
            do {
                guard
                    let resultJson = try JSONDecoder().decode([Product]?.self, from: data)
                else {
                    completion(.failure(ResponseError.unknownAPIResponse))
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
