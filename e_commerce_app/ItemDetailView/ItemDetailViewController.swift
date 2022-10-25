//
//  ItemDetailViewController.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-10-16.
//

import Foundation
import UIKit

class ItemDetailViewController: UIViewController {
    @IBOutlet weak var itemDetailViewItemPrice: UILabel!
    @IBOutlet weak var itemDetailViewImage: UIImageView!
    @IBOutlet weak var itemDetailViewTitle: UILabel!
    @IBOutlet weak var itemDetailViewDescription: UILabel!
    
   var selectedItem: WelcomeElement?
//    {
//        didSet {
//            itemDetailViewTitle.text = selectedItem
//            print(itemDetailViewTitle.text)
//
//        }
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
        self.itemDetailViewTitle.text = selectedItem?.title ?? ""
        self.itemDetailViewDescription.text = selectedItem?.welcomeDescription ?? ""
        
        let itemPrice = selectedItem?.price ?? 0.00 as Double
        let doubleItemPriceString = String(format: "%.2f", itemPrice)
        self.itemDetailViewItemPrice.text = "$ \(doubleItemPriceString)"
        self.navigationController!.navigationBar.topItem?.backButtonTitle = "Return Home"

        let productImageURL = selectedItem?.image
        let url = URL(string: productImageURL!)
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.itemDetailViewImage.image = UIImage(data: data!)
            }
        }
        
    }
    @IBAction func itemDetailViewAddItemToBag(_ sender: Any) {
        
    }
}
