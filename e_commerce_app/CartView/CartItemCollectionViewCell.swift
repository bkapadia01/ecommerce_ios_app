//
//  CartItemCollectionViewCell.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-11-10.
//

import UIKit

class CartItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var itemCellImage: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    
    var deleteThisCell: (() -> Void)?
       @IBAction func deletePressed(_ sender: Any) {
          deleteThisCell?()
           print("deletteee")
       }
    
}

