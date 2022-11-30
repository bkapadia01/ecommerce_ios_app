//
//  HomeCollectionViewController.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-10-09.
//

import UIKit

class HomeCollectionViewController: UICollectionViewController {
    
    private let homeViewModel: HomeViewModel
    private let reuseIdentifier = Constants.Stroyboard.productCellIdentifier
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    init?(homeViewModel: HomeViewModel, coder: NSCoder) {
        self.homeViewModel = homeViewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = AppLocalizable.welcomeTitle.localized() + homeViewModel.getLoggedInUsername() + "!"
        
        homeViewModel.getAllProducts { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self.homeViewModel.productItems = products
                case .failure(let error):
                    print(error)
                }
                
                self.collectionView?.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = homeViewModel.productItems[indexPath.item]
        transitionToItemDetailVC(selectedProduct: selectedProduct)
    }
    
    private func transitionToItemDetailVC(selectedProduct: Product) {
        if let itemDetailViewController = storyboard?.instantiateViewController(identifier: Constants.Stroyboard.itemDetailViewController, creator: { coder in
            let userID = self.homeViewModel.userID
            
            let itemDetailViewModel = ItemDetailViewModel(userID: userID, product: selectedProduct)
            return ItemDetailViewController(itemDetailViewModel: itemDetailViewModel, coder: coder)
        }) {
            navigationController?.pushViewController(itemDetailViewController, animated: true)
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.productItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomeItemCollectionViewCell
        DispatchQueue.global().async {
            let productInfo = self.homeViewModel.getProductInfo(at: indexPath)
            DispatchQueue.main.async {
                self.collectionCellContent(cell: cell, image: productInfo.image, productName: productInfo.productTitle)
            }
        }
        return cell
    }
    
    func collectionCellContent(cell: HomeItemCollectionViewCell, image: UIImage, productName: String) {
        cell.itemImageView.image = image
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 1
        cell.itemLabel.text = productName
    }
}

extension HomeCollectionViewController: UICollectionViewDelegateFlowLayout {
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
