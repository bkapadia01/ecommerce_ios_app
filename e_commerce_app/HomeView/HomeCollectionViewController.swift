//
//  HomeCollectionViewController.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-10-09.
//

import UIKit

private let reuseIdentifier = "ProductCell"


class HomeCollectionViewController: UICollectionViewController {
    
    private let homeViewModel: HomeViewModel
    private var productItems: [Product] = []
    private let reuseIdentifier = "ProductCell"
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
        navigationItem.title = "Welcome " + homeViewModel.getLoggedInUsername() + "!"
        
        homeViewModel.getAllProducts { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self.productItems = products
                    
                case .failure(let error):
                    print(error)
                }
                
                self.collectionView?.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = productItems[indexPath.item]
        
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
    
    //completion, no returns , or returns something but in rare case compeltion and return something - need to understand completion in more detail
    //review nibs/ xibs since thats what TB uses
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomeItemCollectionViewCell
        let productName = productItems[indexPath.item].title
        DispatchQueue.global().async {
            if let productImageURL = self.productItems[indexPath.item].image,
               let url = URL(string: productImageURL),
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.collectionCellContent(cell: cell, image: image, productName: productName ?? "Missing Name")
                }
            } else {
                DispatchQueue.main.async {
                    guard let missingImage = UIImage(named: "missing_image") else {
                        return print("Unable to locate missing image file in assets")
                    }
                    self.collectionCellContent(cell: cell, image: missingImage, productName: productName ?? "Missing Name")
                }
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
