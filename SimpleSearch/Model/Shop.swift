//
//  Shop.swift
//  SimpleSearch
//
//  Created by Raditya Kurnianto on 3/16/18.
//  Copyright © 2018 Raditya. All rights reserved.
//

import Foundation

class Shop {
    var shopType: String?
    var shopSelected: Bool?
    
    init(type: String, selected: Bool) {
        self.shopType = type
        self.shopSelected = selected
    }
}
