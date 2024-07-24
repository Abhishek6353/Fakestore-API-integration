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
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        layer.masksToBounds = false
        backgroundColor = .white
    }
    
    override var isSelected: Bool {
        didSet {
            layer.borderColor = isSelected ? UIColor.green.cgColor : UIColor.lightGray.cgColor
        }
    }

}
