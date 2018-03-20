//
//  ShopCell.swift
//  SimpleSearch
//
//  Created by Raditya Kurnianto on 3/16/18.
//  Copyright © 2018 Raditya. All rights reserved.
//

import UIKit

class ShopCell: UITableViewCell {

    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var shopLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupShop(shop: Shop) -> Void {
        shopLabel.text = shop.shopType
        checkImageView.image = shop.shopSelected! ? UIImage(named: "ic_check") : UIImage(named: "ic_uncheck")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
