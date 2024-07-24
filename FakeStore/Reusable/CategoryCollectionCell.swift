//
//  CategoryCollectionCell.swift
//  FakeStore
//
//  Created by Abhishek on 24/07/24.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell {
    
    var category: String? {
        didSet {
            categoryLabel.text = category
        }
    }
    
    @IBOutlet weak var categoryLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.cornerRadius = 8.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 1.0
        layer.shadowOpacity = 0.75
        layer.masksToBounds = false
        backgroundColor = .white
    }

}
