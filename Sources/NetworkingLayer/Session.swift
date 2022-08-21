//
//  Session.swift
//  Networking
//
//  Created by Noha Mohamed on 19/08/2022.
//

import Foundation

public extension URLSession {
    func request(_ request: RequestProtocol) -> URLRequest {
        let requestMapper = RequestMapper(request)
        let mappedRequest = try! requestMapper.asURLRequest()
        return mappedRequest
    }
}
