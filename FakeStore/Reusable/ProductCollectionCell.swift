//
//  ProductCollectionCell.swift
//  FakeStore
//
//  Created by Abhishek on 23/07/24.
//

import UIKit
import SDWebImage

class ProductCollectionCell: UICollectionViewCell {
    
    var product: Product? {
        didSet {
            setData()
        }
    }
    
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

    private func setData() {
        guard let product else { return }
        
        productTitleLabel.text = product.title
        productPriceLabel.text = "$ \(product.price)"
        productRatingLabel.text = "\(product.rating.rate)"
        
        productImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        productImageView.sd_imageIndicator?.startAnimatingIndicator()
        
        if let imageURL = URL(string: product.image) {
            productImageView.sd_setImage(with: imageURL) { [weak self] _, error, _, _ in
                guard let self else { return }
                self.productImageView.sd_imageIndicator?.stopAnimatingIndicator()
            }
        }
    }
}
