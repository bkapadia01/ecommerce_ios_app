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
    
    enum cartSelectionMode {
        case viewCart
        case editCart
    }
    
    private let cartViewModel: CartViewModel
    private let reuseIdentifier = Constants.Stroyboard.cartItemCellIdentifier
    private var matchingItemOrderCount: Int?
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    let emptyCartImage = UIImage(named: Constants.FileName.emptyCartImage)
    
    init?(cartViewModel: CartViewModel, coder: NSCoder) {
        self.cartViewModel = cartViewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var currentMode: cartSelectionMode = .viewCart {
        didSet {
            switch currentMode {
            case .viewCart:
                editBarButton.title = AppLocalizable.edit.localized()
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: AppLocalizable.checkOut.localized(), style: .plain, target: self, action: #selector(checkoutCartItems))
            case .editCart:
                editBarButton.title = AppLocalizable.cancel.localized()
                navigationItem.rightBarButtonItem = deleteBarButton
                collectionView.allowsMultipleSelection = true
            }
        }
    }
    
    lazy var editBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: AppLocalizable.edit.localized(), style: .plain, target: self, action: #selector(selectToEditItemsInCart(_:)))
        return barButtonItem
    }()
    
    lazy var deleteBarButton: UIBarButtonItem = {
        let deleteBarButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(selectDeleteItemsInCart(_:)))
        return deleteBarButton
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        cartViewModel.orderItems = try? cartViewModel.getOrderItemsForLoggedInUser()
        currentMode = .viewCart
        setupBarButtonItems()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: AppLocalizable.checkOut.localized(), style: .plain, target: self, action: #selector(checkoutCartItems))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = AppLocalizable.yourCart.localized()
        
    }
    
    @objc func selectToEditItemsInCart(_ sender: UIBarButtonItem) {
        currentMode = currentMode == .viewCart ? .editCart : .viewCart
        if currentMode == .viewCart {
            collectionView.reloadData()
        }
    }
    
    @objc func selectDeleteItemsInCart(_ sender: UIBarButtonItem) {
        cartViewModel.deleteSelectedItemsFromCart()
        collectionView.reloadData()
    }
    
    private func setupBarButtonItems() {
        navigationItem.leftBarButtonItem = editBarButton
    }
    
    @objc func checkoutCartItems() {
        let checkOutItemsInCartAC = UIAlertController(title: AppLocalizable.checkOutItemCart.localized(), message: AppLocalizable.wouldCheckoutItemsCart.localized(), preferredStyle: UIAlertController.Style.alert)
        checkOutItemsInCartAC.addAction(UIAlertAction(title: AppLocalizable.checkOutItems.localized(), style: .default, handler: { _ in
            do {
                try self.cartViewModel.productDetailToSaveToCart()
                self.collectionView.reloadData()
            } catch {
                print(error)
            }
        }))
        checkOutItemsInCartAC.addAction(UIAlertAction(title: AppLocalizable.cancel.localized(), style:.cancel, handler: nil))
        self.present(checkOutItemsInCartAC, animated: true, completion: nil)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        do {
            let orderItem = try cartViewModel.getOrderItemsForLoggedInUser()
            let orderItemCount = orderItem.count
            if orderItemCount != 0 {
                showEmptyCartImage(isHidden: true)
                return orderItemCount
            } else {
                showEmptyCartImage(isHidden: false)
                return 0
            }
        } catch {
            return 0
        }
    }
    
    func showEmptyCartImage(isHidden: Bool) {
        let imageView = UIImageView(image: emptyCartImage)
        imageView.tag = 100
        imageView.frame = CGRect(x: 0, y: 200, width: 400, height: 400)
        if isHidden {
            let viewWithTag = self.view.viewWithTag(100)
            viewWithTag?.removeFromSuperview()
        } else {
            view.addSubview(imageView)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CartItemCollectionViewCell
        DispatchQueue.global().async {
            let productInfo = self.cartViewModel.getCartProductInfo(at: indexPath)
            DispatchQueue.main.async {
                self.collectionCellContent(cell: cell, image: productInfo.image, itemName: productInfo.productTitle)
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch currentMode {
        case .viewCart:
            collectionView.deselectItem(at: indexPath, animated: true)
        case .editCart:
            cartViewModel.dictionaryIndexPathOfSelectedItem[indexPath] = true
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if currentMode == .editCart {
            cartViewModel.dictionaryIndexPathOfSelectedItem[indexPath] = false
        }
    }
    
    func collectionCellContent(cell: CartItemCollectionViewCell, image: UIImage, itemName: String) {
        cell.itemCellImage.image = image
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 1
        cell.itemNameLabel.text = itemName
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
