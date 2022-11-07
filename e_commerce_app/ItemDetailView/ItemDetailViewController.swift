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
    @IBOutlet weak var itemDetailViewDescription: PaddingLabel!
    
    private let itemDetailViewModel: ItemDetailViewModel
    
    
    init?(itemDetailViewModel: ItemDetailViewModel, coder: NSCoder) {
        self.itemDetailViewModel = itemDetailViewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let itemPrice = itemDetailViewModel.product.price ?? 0.00 as Double
        let doubleItemPriceString = String(format: "%.2f", itemPrice)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
        self.itemDetailViewDescription.text = itemDetailViewModel.product.productDescription ?? ""
        self.itemDetailViewTitle.text = itemDetailViewModel.product.title ?? ""
        self.itemDetailViewItemPrice.text = "$ \(doubleItemPriceString)"
        self.navigationController?.navigationBar.topItem?.backButtonTitle = "Return Home"
        
        if let productImageURL = itemDetailViewModel.product.image{
            let url = URL(string: productImageURL)
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.itemDetailViewImage.image = UIImage(data: data!)
                }
            }
        }
    }
    
    @IBAction func itemDetailViewAddItemToBag(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        itemDetailViewModel.productDetailToSaveToCart(appDelegate: appDelegate)
        
        let itemAddedToCartAlert = UIAlertController(title: "Item added to cart!", message: "View item in cart to checkout", preferredStyle: UIAlertController.Style.alert)
        itemAddedToCartAlert.addAction(UIAlertAction(title: "OK", style:.cancel, handler: nil))
        self.present(itemAddedToCartAlert, animated: true, completion: nil)
    }
}
