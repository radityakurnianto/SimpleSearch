//
//  SearchViewModel.swift
//  SimpleSearch
//
//  Created by Raditya Kurnianto on 9/4/18.
//  Copyright © 2018 Raditya. All rights reserved.
//

import Foundation
import Alamofire

class SearchViewModel: NSObject {
    var startValue = 0
    var arrayOfProducts: [Product]?
    var searchFilter: FilteredValue?
    var requesting: Bool?
    var isLastPage: Bool?
    
    override init() {
        arrayOfProducts = Array()
        super.init()
    }
    
    func numberOfItemInSection(section: Int) -> Int {
        if section == 0 {
            return (arrayOfProducts?.count)!
        } else {
            return isLastPage! ? 0 : 1
        }
    }
    
    func search(completion: @escaping (_ error: Error?) -> Void) {
        if !requesting! {
            return
        }
        
        Alamofire.request(Router.Search.get(filter: searchFilter, start: startValue)).validate().responseJSON { (response) in
            self.requesting = false
            
            print("Search_URL -> " + (response.request?.url?.absoluteString)!)
            switch response.result {
            case .success:
                do {
                    guard let data = response.data else { return }
                    let products = try JSONDecoder().decode(ProductList.self, from: data)
                    
                    guard var tempArray = products.data else { return }
                    self.arrayOfProducts?.append(contentsOf: tempArray as [Product])
                    tempArray.removeAll()
                    
                    self.startValue += 10 // behave as pagination
                    self.isLastPage = self.startValue > (products.header?.totalProduct)!
                    
                    print("startValue = " + String(self.startValue))
                    completion(nil)
                } catch let error {
                    print(error.localizedDescription)
                    completion(error)
                }
            case .failure(let error):
                print("Error : " + error.localizedDescription)
                completion(error)
            }
        }
    }
}
