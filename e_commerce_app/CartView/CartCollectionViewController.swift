//
//  CartCollectionViewController.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-11-05.
//

import UIKit

private let reuseIdentifier = "Cell"

// NOT PART OF THIS PR
class CartCollectionViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Your Cart"
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: view.frame.width, height: 250)
    }
}

