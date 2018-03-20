//
//  LoadingCell.swift
//  SimpleSearch
//
//  Created by Raditya Kurnianto on 3/16/18.
//  Copyright © 2018 Raditya. All rights reserved.
//

import UIKit

class LoadingCell: UICollectionViewCell {

    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func startAnimation() -> Void {
        UIView.animate(withDuration: 0.8, delay: 0.5, options: [.repeat,.autoreverse], animations: {
            self.view1.alpha = 0.5
            self.view2.alpha = 0.5
            self.view3.alpha = 0.5
        }, completion: nil)
    }
}
