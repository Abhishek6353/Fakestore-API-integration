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
    var categories: [String] = []
    
    //MARK: - Outlets
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "FakeStore"
        
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.register(UINib(nibName: ProductCollectionCell.className, bundle: nil), forCellWithReuseIdentifier: ProductCollectionCell.className)
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(UINib(nibName: CategoryCollectionCell.className, bundle: nil), forCellWithReuseIdentifier: CategoryCollectionCell.className)
        
        getCategory()
        getProduct()
    }
    
    
    //MARK: - Button Actions
    
    
    //MARK: - Functions
    
    private func getCategory() {
        MVCServer().serviceRequestWithURL(reqMethod: .get, withUrl: "products/categories", withParam: [:], expecting: [String].self, displayHud: false, includeToken: false) { responseCode, categories, error in
            if let error = error {
                self.handleError(error)
                return
            }
            
            guard let categories else {
                return
            }
            
            self.categories = categories
            self.categoryCollectionView.reloadData()
        }
    }
    
    private func getProduct(by category: String = "") {
        let endPoint = category == "" ? "products" : "products/category/\(category)"
        
        MVCServer().serviceRequestWithURL(reqMethod: .get, withUrl: endPoint, withParam: [:], expecting: [Product].self, displayHud: true, includeToken: false) { _, products, error in
            
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
        return collectionView == categoryCollectionView ? categories.count : products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == categoryCollectionView {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionCell.className, for: indexPath) as? CategoryCollectionCell else {
                return UICollectionViewCell()
            }
            cell.category = categories[indexPath.row]
            
            return cell
            
        } else {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionCell.className, for: indexPath) as? ProductCollectionCell else {
                return UICollectionViewCell()
            }
            cell.product = products[indexPath.row]
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            getProduct(by: categories[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return collectionView == categoryCollectionView ? UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0) : UIEdgeInsets(top: 15.0, left: 1.0, bottom: 10.0, right: 1.0)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let gridLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 2 - gridLayout.minimumInteritemSpacing

        return collectionView == categoryCollectionView ? CGSize() : CGSize(width: widthPerItem, height: (widthPerItem * 1.5))
    }
}
