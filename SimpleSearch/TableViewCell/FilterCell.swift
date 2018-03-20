//
//  FilterCell.swift
//  SimpleSearch
//
//  Created by Raditya Kurnianto on 3/16/18.
//  Copyright © 2018 Raditya. All rights reserved.
//

import UIKit
import WARangeSlider

class FilterCell: UITableViewCell {
    @IBOutlet weak var pminLabel: UILabel!
    @IBOutlet weak var pmaxLabel: UILabel!
    @IBOutlet weak var wholesaleSwitch: UISwitch!
    @IBOutlet weak var rangeSlider: RangeSlider!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let formatter = NumberFormatter()
    var rawPrice: Price?
    var prettyPrice: FormattedPrice?
    
    var pmin: Double = minSliderValue
    var pmax: Double = maxSliderValue
    var selectedShop: [Shop]?
    
    var onSelection: ((UIViewController) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedShop = Array()
        
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID")
        
        rangeSlider.addTarget(self, action: #selector(FilterCell.rangeSliderValueChanged(_:)), for: .valueChanged)
        rangeSlider.minimumValue = pmin
        rangeSlider.maximumValue = pmax
        
        rawPrice = (pmin, pmax)
        
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: String(describing: SelectedShopCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: SelectedShopCell.self))
        
        self.resetAllValue()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
    //MARK: cell function
    func setupFilterCell(shouldReset: Bool, applyFilter:FilteredValue?) -> Void {
        if shouldReset {
            self.resetAllValue()
            return
        }
        
        self.setupPreviousFilter(filtered: applyFilter)
    }
    
    func getFilterValue() -> FilteredValue {
        var official = false
        var gold = false
        
        for item in selectedShop! {
            if item.shopType == goldMerchant {
                gold = true
            }
            
            if item.shopType == officialStore {
                official = true
            }
        }
        
        let filter: FilteredValue =
            [   "pmin"         : self.convertToFixPrice(price: (rawPrice?.0)!) ,
                "pmax"         : self.convertToFixPrice(price: (rawPrice?.1)!) ,
                "wholesale"    : wholesaleSwitch.isOn,
                "official"     : official,
                "fshop"        : gold ? "2" : "0",
            ]
        return filter
    }
    
    func setupPreviousFilter(filtered: FilteredValue?) -> Void {
        guard let filter = filtered else {
            return
        }
        
        selectedShop?.removeAll()
        pmin = Double(filter["pmin"] as!Int) / 1000000
        pmax = Double(filter["pmax"] as!Int) / 1000000
        
        rawPrice = (pmin, pmax)
        
        prettyPrice = self.convertToIDR(priceRange: rawPrice!)
        
        // reset all UIControl
        pminLabel.text = prettyPrice?.0
        pmaxLabel.text = prettyPrice?.1
        
        rangeSlider.lowerValue = pmin
        rangeSlider.upperValue = pmax
        
        wholesaleSwitch.setOn(filter["wholesale"] as! Bool, animated: true)
        
        
        if filter["official"] as! Bool == true {
            selectedShop?.append(Shop(type: officialStore, selected: true))
        }
        
        if filter["fshop"] as! String == "2" {
            selectedShop?.append(Shop(type: goldMerchant, selected: true))
        }
        
        collectionView.reloadData()
    }
    
    @objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
        rawPrice = (rangeSlider.lowerValue, rangeSlider.upperValue)
        prettyPrice = self.convertToIDR(priceRange: rawPrice!)
        
        pminLabel.text = prettyPrice?.0
        pmaxLabel.text = prettyPrice?.1
    }
    
    @IBAction func shopButton(_ sender: Any) {
        let shop: ShopController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShopController") as! ShopController
        shop.delegate = self
        shop.selectedShop = selectedShop
        onSelection?(shop)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension FilterCell: ShopDelegate {
    func didReceiveSelectedShop(shops: [Shop]) {
        selectedShop = shops
        collectionView.reloadData()
    }
    
    func resetAllValue() -> Void {
        selectedShop?.removeAll()
        pmin = minSliderValue
        pmax = maxSliderValue
        
        rawPrice = (pmin, pmax)
        
        prettyPrice = self.convertToIDR(priceRange: rawPrice!)
        
        // reset all UIControl
        pminLabel.text = prettyPrice?.0
        pmaxLabel.text = prettyPrice?.1
        
        rangeSlider.lowerValue = pmin
        rangeSlider.upperValue = pmax
        
        wholesaleSwitch.setOn(false, animated: true)
        collectionView.reloadData()
    }
    
    func convertToIDR(priceRange: Price) -> FormattedPrice {
        let lower = (priceRange.0 * 1000000) as NSNumber
        let upper = (priceRange.1 * 1000000) as NSNumber
        
        let tempPrice = (formatter.string(from: lower)!, formatter.string(from: upper)!)
        return tempPrice
    }
    
    func convertToFixPrice(price: Double) -> Int {
        return Int(price * 1000000)
    }
}

extension FilterCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (selectedShop?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SelectedShopCell.self), for: indexPath) as! SelectedShopCell
        cell.setupSelectedShop(shop: selectedShop![indexPath.row])
        cell.onClick = { (result) -> () in
            if let index = self.selectedShop?.index(where: {$0.shopType == result.shopType}) {
                self.selectedShop?.remove(at: index)
                print("did_click " + result.shopType!)
                collectionView.reloadData()
            }
        }
        return cell
    }
}
