//
//  ViewController.swift
//  FakeStore
//
//  Created by Abhishek on 21/07/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Products"
        
        
        productCollectionView.register(UINib(nibName: "ProductCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionCell")
        
        
    }
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionCell", for: indexPath) as? ProductCollectionCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    
}

