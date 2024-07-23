//
//  ViewController.swift
//  FakeStore
//
//  Created by Abhishek on 21/07/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Variables
    var products: [Product] = []
    
    //MARK: - Outlets
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "FakeStore"
        
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.register(UINib(nibName: "ProductCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionCell")
        
        getProduct()
    }
    
    
    //MARK: - Button Actions
    
    
    //MARK: - Functions
    
    private func getProduct() {
        MVCServer().serviceRequestWithURL(reqMethod: .get, withUrl: "products", withParam: [:], expecting: [Product].self, displayHud: true, includeToken: false) { _, products, error in
            
            if let error = error {
                self.handleError(error)
                return
            }
            
            guard let products else {
                return
            }
            
            self.products = products
            self.productCollectionView.reloadData()
            
        }
    }
    
    private func handleError(_ error: NetworkError) {
        DispatchQueue.main.async {
            // Show an alert or toast with the error description
            self.view.makeToast(error.localizedDescription, position: .top)
        }
    }

    
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionCell", for: indexPath) as? ProductCollectionCell else {
            return UICollectionViewCell()
        }
        cell.product = products[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.0, left: 1.0, bottom: 10.0, right: 1.0)
    }
    
    //MARK: - SizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let gridLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 2 - gridLayout.minimumInteritemSpacing
        return CGSize(width:widthPerItem, height:(widthPerItem * 1.5))
    }
}
