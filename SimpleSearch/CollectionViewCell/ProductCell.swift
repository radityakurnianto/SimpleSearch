//
//  ProductCell.swift
//  SimpleSearch
//
//  Created by Raditya Kurnianto on 3/15/18.
//  Copyright © 2018 Raditya. All rights reserved.
//

import UIKit
import SDWebImage

class ProductCell: UICollectionViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productTitleLabel: UILabel! 
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func displayProduct(product: Product) -> Void {
        productTitleLabel.text = product.name
        productPriceLabel.text = product.price
        productImageView.sd_setImage(with: product.imageUri, placeholderImage: UIImage(named: "placeholder"))
    }
}
