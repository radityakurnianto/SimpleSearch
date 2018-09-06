//
//  ProductList.swift
//  SimpleSearch
//
//  Created by Raditya Kurnianto on 3/16/18.
//  Copyright © 2018 Raditya. All rights reserved.
//

import Foundation

struct ProductList: Decodable {
    let data: [Product]?
    let status: Status?
    let header: Header?
}

struct Product: Decodable {
    var id: Int?
    var name: String?
    var uri: URL?
    var imageUri: URL?
    var price: String?
    var wholesale: Wholesale?
//    var shop: Shop?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case uri = "uri"
        case imageUri = "image_uri"
        case price = "price"
        case wholesale = "labels"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            if let id = try? container.decodeIfPresent(Int.self, forKey: .id) {
                self.id = id
            }
            
            if let name = try? container.decodeIfPresent(String.self, forKey: .name) {
                self.name = name
            }
            
            if let uri = try? container.decodeIfPresent(URL.self, forKey: .uri) {
                self.uri = uri
            }
            
            if let imageURI = try? container.decodeIfPresent(URL.self, forKey: .imageUri) {
                self.imageUri = imageURI
            }
            
            if let price = try? container.decodeIfPresent(String.self, forKey: .price) {
                self.price = price
            }
            
            if let wholesale = try? container.decodeIfPresent(Wholesale.self, forKey: .wholesale) {
                self.wholesale = wholesale
            }
        } catch let error {
            print("error = " + error.localizedDescription)
        }
    }
}

struct Header: Decodable {
    var totalProduct: Int?
    
    private enum CodingKeys: String, CodingKey {
        case totalProduct = "total_data"
    }
}

struct Wholesale: Decodable {
    var title: String?
    var color: String?
}

struct Status: Decodable {
    let errorCode: Int?
    let message: String?
    
    private enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message = "message"
    }
}
