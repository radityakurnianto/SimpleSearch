//
//  Router.swift
//  SimpleSearch
//
//  Created by Raditya Kurnianto on 3/15/18.
//  Copyright © 2018 Raditya. All rights reserved.
//

import Foundation
import Alamofire

struct Router: URLRouter {
    static var basePath: String {
        return "https://ace.tokopedia.com/search/v2.5/"
    }
    
    struct Search: Readable {
        var route = "product"
    }
}
