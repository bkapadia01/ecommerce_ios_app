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
    private var productItems: [WelcomeElement] = []
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
        let selectedItem = productItems[indexPath.item]
        self.performSegue(withIdentifier: "segueToItemDetailView", sender: selectedItem)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
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
               let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    cell.itemImageView.image = UIImage(data: data)  // try to reduce repeatetive code with the else portion
                    cell.layer.borderColor = UIColor.gray.cgColor
                    cell.layer.borderWidth = 1
                    cell.itemLabel.text = productName
                }
            } else {
                DispatchQueue.main.async {
                    cell.itemImageView.image = UIImage(named: "missing_image")
                    cell.layer.borderColor = UIColor.gray.cgColor
                    cell.layer.borderWidth = 1
                    cell.itemLabel.text = productName
                }
            }
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let selectedItem = sender else {
            return
        }
        
        if segue.identifier == "segueToItemDetailView" {
            guard let itemDetailVC = segue.destination as? ItemDetailViewController,
                  let selectedIndexPath = self.collectionView.indexPathsForSelectedItems?.last?.row
            else {
                return
            }
            
            itemDetailVC.selectedItem = productItems[selectedIndexPath]
            print(productItems[selectedIndexPath].title ?? "") // For test purposes - remove on final code
        }
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
