//
//  SelectedShopCell.swift
//  SimpleSearch
//
//  Created by Raditya Kurnianto on 3/16/18.
//  Copyright © 2018 Raditya. All rights reserved.
//

import UIKit

class SelectedShopCell: UICollectionViewCell {

    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var selectedShopButton: ImageButton!
    @IBOutlet weak var selectedShopLabel: UILabel!
    var aShop: Shop?
    
    var onClick: ((Shop) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
         super.layoutSubviews()
        roundedView.layer.cornerRadius = 8.0
        roundedView.layer.borderColor = UIColor.lightGray.cgColor
        roundedView.layer.borderWidth = 0.5
    }

    func setupSelectedShop(shop: Shop) -> Void {
        aShop = shop
        selectedShopLabel.text = shop.shopType
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        onClick?(aShop!)
    }
}
