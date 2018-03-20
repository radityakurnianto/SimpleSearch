//
//  RequestConverter.swift
//  SimpleSearch
//
//  Created by Raditya Kurnianto on 3/15/18.
//  Copyright © 2018 Raditya. All rights reserved.
//

import Foundation
import Alamofire

struct RequestConverter: RequestConverterProtocol {
    var method: HTTPMethod
    var route: String
    var parameters: Parameters = [:]
    
    init(method: HTTPMethod, route: String, parameters: Parameters = [:]) {
        self.method = method
        self.route = route
        self.parameters = parameters
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.basePath.asURL()
        let urlRequest = URLRequest(url: url.appendingPathComponent(route))
        
        return try URLEncoding.default.encode(urlRequest, with: parameters)
    }
    
    private func authorizationHeader(user: String, password: String) -> String {
        guard let data = "\(user):\(password)".data(using: .utf8) else { return "" }
        let credential = data.base64EncodedString(options: [])
        return "Basic \(credential)"
    }
}
