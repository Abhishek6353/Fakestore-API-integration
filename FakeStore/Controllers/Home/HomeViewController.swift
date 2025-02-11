//
//  ViewController.swift
//  FakeStore
//
//  Created by Abhishek on 21/07/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Variables
    var selectedIndex = 0

    var products: [Product] = []
    var filteredProducts: [Product] = []
    var categories: [String] = []
    let searchController = UISearchController()

    
    //MARK: - Outlets
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "FakeStore"
        self.navigationItem.searchController = searchController
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.placeholder = "Products"
        
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
            self.categories.insert("All", at: 0)
            self.categoryCollectionView.reloadData()
            
            self.categoryCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .top)
            self.collectionView(self.categoryCollectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
        }
    }
    
    private func getProduct(by category: String = "") {
        let endPoint = category == "" ? "products" : category == "All" ? "products" : "products/category/\(category)"
        
        MVCServer().serviceRequestWithURL(reqMethod: .get, withUrl: endPoint, withParam: [:], expecting: [Product].self, displayHud: true, includeToken: false) { _, products, error in
            
            if let error = error {
                self.handleError(error)
                return
            }
            
            guard let products else {
                return
            }
            
            self.products = products
            self.filteredProducts = products
            self.productCollectionView.reloadData()
        }
    }
    
    private func handleError(_ error: NetworkError) {
        DispatchQueue.main.async {
            self.view.makeToast(error.localizedDescription, position: .top)
        }
    }
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == categoryCollectionView ? categories.count : filteredProducts.count
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
            cell.product = filteredProducts[indexPath.row]
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            if indexPath.row != selectedIndex {
                getProduct(by: categories[indexPath.row])
                selectedIndex = indexPath.row
            }
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


//MARK: - UISearchController methods
extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text.count > 0 {
            filteredProducts = products.filter( { $0.title.lowercased().contains(text.lowercased())})
        } else {
            filteredProducts = products
        }
        productCollectionView.reloadData()
    }
}
