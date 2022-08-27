//
//  MockRequest.swift
//  
//
//  Created by Noha Mohamed on 21/08/2022.
//

import Foundation
import NetworkingLayer

struct MockRequest: RequestProtocol {
    var cacheRequest: Bool?
    
    var headers: HTTPHeaders?
    
    var baseURL: String = ""
    
    var endPoint: String = ""
    
    var parameters: Parameters?
    var method: HTTPMethod = .get
    
    init(baseURL: String , endPoint: String) {
        self.baseURL = baseURL
        self.endPoint = endPoint
    }
    init(){}
}
