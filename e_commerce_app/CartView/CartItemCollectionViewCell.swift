//
//  CartItemCollectionViewCell.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-11-10.
//

import UIKit

class CartItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var itemImageCell: UIImageView!
    @IBOutlet weak var itemLabelCell: UILabel!
    
    var deleteThisCell: (() -> Void)?
       @IBAction func deleteItemPressed(_ sender: Any) {
          deleteThisCell?()
       }
}
