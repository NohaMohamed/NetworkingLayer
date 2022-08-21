//
//  Request.swift
//  Networking
//
//  Created by Noha Mohamed on 19/08/2022.
//

import Foundation
struct RequestMapper {
    
    var request: RequestProtocol
    
    init(_ request: RequestProtocol) {
        self.request = request
    }
    
    func asURLRequest() throws -> URLRequest {
        if let url = URL(string: request.baseURL+request.endPoint) {
            var urlRequest = URLRequest(url: url)
            let method = request.method
            urlRequest.httpMethod = method.rawValue
            
            if method == .get {
                urlRequest.allHTTPHeaderFields = request.headers
                urlRequest.httpMethod = method.rawValue
                let queryItems = request.parameters?.map {
                    URLQueryItem(name: $0, value: $1)
                }
                if let items = queryItems {
                    urlRequest.addQuery(query: items)}
                return urlRequest
            }
            
            return urlRequest
        }
        throw CustomNetworkError.canNotMapRequest
    }
}
extension URLRequest {
    mutating func addQuery(query: [URLQueryItem]) {
        guard let url = self.url else { return }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = query
        let body = urlComponents?.query?.data(using: .utf8)
        switch self.httpMethod {
        case HTTPMethod.post.rawValue:
            self.httpBody = body
        case HTTPMethod.get.rawValue:
            self.url = urlComponents?.url
        default:
            break
        }
    }
}
