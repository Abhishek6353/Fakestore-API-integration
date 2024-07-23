//
//  ProductCollectionCell.swift
//  FakeStore
//
//  Created by Abhishek on 23/07/24.
//

import UIKit

class ProductCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productRatingLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    

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
