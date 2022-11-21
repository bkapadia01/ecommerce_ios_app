//
//  CartCollectionViewController.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-11-05.
//

import UIKit

struct ItemIdCount {
    let id: Int
    let quantity: Int
}


class CartCollectionViewController : UICollectionViewController {
    
    private let cartViewModel: CartViewModel
    private let reuseIdentifier = "CartItemCell"
    private var orderItems: [OrderItem]? = []
    private var orderItemCount: [ItemIdCount] = []

    private var matchingItemOrderCount: Int?
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

    init?(cartViewModel: CartViewModel, coder: NSCoder) {
        self.cartViewModel = cartViewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        orderItems = try? cartViewModel.getOrderItemsForLoggedInUser()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Your Cart"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Checkout", style: .plain, target: self, action: #selector(checkoutCartItems))
//        for orderItemz in orderItems! {
//            Dictionary(grouping: orderItemz, by: {orderItemz.id})
//            print(orderItemz.id)
//        }
        let x = Dictionary(grouping: orderItems!, by: { $0.id })
        print(x)

//        var array: [Int: Int] = [:]
//        for y in x {
////            y.value.count
//            let b = [y.key:y.value.count]
//            print(b)
////          print(y.key, y.value.count)
//        }
    }
    @objc func checkoutCartItems() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let checkOutItemsInCartAC = UIAlertController(title: "Checkout Items In Cart", message: "Would you like to checkout the items in cart? ", preferredStyle: UIAlertController.Style.alert)
        checkOutItemsInCartAC.addAction(UIAlertAction(title: "Checkout Items", style: .default, handler: { _ in
            
            do {
               try self.cartViewModel.productDetailToSaveToCart(appDelegate: appDelegate)
            } catch {
                print("fail")
            }
        }))
        checkOutItemsInCartAC.addAction(UIAlertAction(title: "No", style:.cancel, handler: nil))

        self.present(checkOutItemsInCartAC, animated: true, completion: nil)
        
      
    
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        do {
            let orderItem = try cartViewModel.getOrderItemsForLoggedInUser()
            let orderItemCount = orderItem.count
            return orderItemCount
        } catch {
            return 0
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CartItemCollectionViewCell
    
        let orderItem = orderItems?[indexPath.item]
        
        DispatchQueue.global().async {
            if let orderItemImageURL =  URL(string: orderItem?.image ?? "missing_image"),
               let data = try? Data(contentsOf: orderItemImageURL),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.collectionCellContent(cell: cell, image: image, itemName: orderItem?.name ?? "Missing Name")
                }
            } else {
                DispatchQueue.main.async {
                    guard let missingImage = UIImage(named: "missing_image") else {
                        return print("Unable to locate missing image file in assets")
                    }
                    self.collectionCellContent(cell: cell, image: missingImage, itemName: orderItem?.name ?? "Missing Name")
                }
            }
        }
        return cell
    }
    
    
    func collectionCellContent(cell: CartItemCollectionViewCell, image: UIImage, itemName: String) {
        cell.itemImageCell.image = image
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 1
        cell.itemLabelCell.text = itemName
    }
}

extension CartCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath ) -> CGSize {

        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int ) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int ) -> CGFloat {
        return sectionInsets.left
    }
}
