//
//  ImageButton.swift
//  SimpleSearch
//
//  Created by Raditya Kurnianto on 3/16/18.
//  Copyright © 2018 Raditya. All rights reserved.
//

import UIKit

class ImageButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
    }
}
