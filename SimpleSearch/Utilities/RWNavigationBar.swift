//
//  RWNavigationBar.swift
//  SimpleSearch
//
//  Created by Raditya Kurnianto on 3/15/18.
//  Copyright © 2018 Raditya. All rights reserved.
//

import UIKit

class RWNavigationBar: UINavigationBar {
    private let hiddenStatusBar: Bool
    
    // MARK: Init
    init(hiddenStatusBar: Bool = false) {
        self.hiddenStatusBar = hiddenStatusBar
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.hiddenStatusBar = false
        super.init(coder: aDecoder)
    }
    
    // MARK: Overrides
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if #available(iOS 11.0, *) {
            for subview in self.subviews {
                let stringFromClass = NSStringFromClass(subview.classForCoder)
                if stringFromClass.contains("BarBackground") {
                    subview.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 64)
                } else if stringFromClass.contains("BarContentView") {
                    subview.frame.origin.y = 20
                    subview.frame.size.height = 44
                }
            }
        }
    }
}
