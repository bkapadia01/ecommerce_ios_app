//
//  OrderItem.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-11-01.
//

import Foundation

struct OrderItem: Codable {
    let id: Int
    let name: String
    let price: Double
    let image: String
}
