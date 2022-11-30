//
//  ProductsAPI.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-10-08.
//

import Foundation

// MARK: - Product
struct Product: Codable {
    var id: Int?
    var title: String?
    var price: Double?
    var productDescription: String?
    var category: Category?
    var image: String?
    var rating: Rating?
    
    enum CodingKeys: String, CodingKey {
        case id, title, price
        case productDescription = "description"
        case category, image, rating
    }
}

enum Category: String, Codable {
    case electronics = "electronics"
    case jewelery = "jewelery"
    case menSClothing = "men's clothing"
    case womenSClothing = "women's clothing"
}

// MARK: - Rating
struct Rating: Codable {
    var rate: Double?
    var count: Int?
}

