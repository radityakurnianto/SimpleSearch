//
//  ShopController.swift
//  SimpleSearch
//
//  Created by Raditya Kurnianto on 3/16/18.
//  Copyright © 2018 Raditya. All rights reserved.
//

import UIKit

protocol ShopDelegate {
    func didReceiveSelectedShop(shops: [Shop])
}

class ShopController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBarHeight: NSLayoutConstraint!
    
    var delegate: ShopDelegate?
    var arrayOfShop: [Shop]?
    var selectedShop: [Shop]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationBarHeight.constant = 64
    }
    
    func setupTableView() -> Void {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: String(describing: ShopCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ShopCell.self))
        
        let goldShop = Shop(type: goldMerchant, selected: false)
        let offShop = Shop(type: officialStore, selected: false)
        
        arrayOfShop = [goldShop, offShop]
        
        guard let shops = selectedShop else {
            return
        }
        
        if shops.count > 0 {
            for item in selectedShop! {
                if item.shopType == goldMerchant {
                    goldShop.shopSelected = item.shopSelected
                }
                
                if item.shopType == officialStore {
                    offShop.shopSelected = item.shopSelected
                }
            }
        }
        
        
        tableView.reloadData()
    }
    
    //MARK: Button Action
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetButton(_ sender: Any) {
        for shop in arrayOfShop! {
            shop.shopSelected = false
        }
        
        tableView.reloadData()
    }
    
    @IBAction func applyButton(_ sender: Any) {
        var tempArray:[Shop] = Array()
        
        for item in arrayOfShop! {
            if item.shopSelected! {
                tempArray.append(item)
            }
        }
        
        delegate?.didReceiveSelectedShop(shops: tempArray)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ShopController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (arrayOfShop?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShopCell.self), for: indexPath) as! ShopCell
        cell.setupShop(shop: arrayOfShop![indexPath.row])
        return cell
    }
}

extension ShopController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let shop = arrayOfShop![indexPath.row]
        let selected = shop.shopSelected
        shop.shopSelected = !selected!
        tableView.reloadData()
    }
}
