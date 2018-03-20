//
//  RoutesProtocol.swift
//  SimpleSearch
//
//  Created by Raditya Kurnianto on 3/15/18.
//  Copyright © 2018 Raditya. All rights reserved.
//

import Foundation
import Alamofire

protocol URLRouter {
    static var basePath: String { get }
}

protocol Routable {
    typealias Parameters = [String : Any]
    var route: String {get set}
    init()
}

//MARK: - List of HTTPMethod
protocol Creatable: Routable {} // GET
protocol Readable: Routable {} // POST

//MARK: - List of Extension
extension Routable {
    init() {
        self.init()
    }
}

extension Creatable where Self: Routable {
    
}

extension Readable where Self: Routable {
    static func get(filter: FilteredValue?, start: Int) -> RequestConverter {
        let temp = Self.init()
        let route = "\(temp.route)"
        
        var params: Parameters? = Parameters()
        if filter != nil {
            params = filter
        }
        
        // add value
        params?.updateValue("samsung", forKey: "q")
        params?.updateValue(start, forKey: "start")
        params?.updateValue("10", forKey: "rows")
        
        return RequestConverter(method: .get, route: route, parameters: params!)
    }
}

protocol RequestConverterProtocol: URLRequestConvertible {
    var method: HTTPMethod {get set}
    var route: String {get set}
    var parameters: Parameters {get set}
}
