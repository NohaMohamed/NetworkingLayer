//
//  APICleint.swift
//  Networking
//
//  Created by Noha Mohamed on 18/08/2022.
//

import Foundation

public protocol APICleintProtocol {
    func send<ResponsType>(request: RequestProtocol, compeletion: @escaping (Result<ResponsType, CustomNetworkError>) -> Void) where ResponsType: Codable
}

open class APICleint {
    
    public static let shared = APICleint()
    
    private init() {}
    
    let urlCache = URLCache.shared
}

extension APICleint: APICleintProtocol {
    
    public func send<ResponsType>(request: RequestProtocol, compeletion: @escaping (Result<ResponsType, CustomNetworkError>) -> Void) where ResponsType : Codable {
        
        let session = URLSession.shared
        let urlrequest = session.request(request)
        getCachedResponse(request: urlrequest) { result  in
            switch result{
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(ResponsType.self, from: data)
                    compeletion(Result.success(decodedData))
                }
                catch let error {
                    print("Failed to decode JSON\(error)")
                    compeletion(Result.failure(.canNotDecodeObject))
                }
            case .failure(let error):
                print("Failed to get cahed request\(error)")
                let task = session.dataTask(with: urlrequest, completionHandler: { (data, response, _) in
                    guard let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode == .some(200) else {
                        compeletion(Result.failure(.generic))
                        return
                    }
                    guard let data = data , let response = response else {
                        compeletion(Result.failure(.generic))
                        return
                    }
                    do {
                        let decodedData = try JSONDecoder().decode(ResponsType.self, from: data)
                        compeletion(Result.success(decodedData))
                        if request.cacheRequest ?? false { self.cacheRequest(data: data, response: response, request: urlrequest) }
                    }
                    catch let error {
                        print("Failed to decode JSON\(error)")
                        compeletion(Result.failure(.canNotDecodeObject))
                    }
                    if let result = String(data: data, encoding: .utf8) {
                        print(result)
                    }
                })
                task.resume()
            }
        }
        
    }
    func cacheRequest(data: Data, response: URLResponse, request: URLRequest) {
        let cachedResponse = CachedURLResponse(response: response, data: data)
        urlCache.storeCachedResponse(cachedResponse, for: request)
    }
    func getCachedResponse(request: URLRequest, completion: @escaping (Result<Data, CustomNetworkError>) -> Void) {
        let data = urlCache.cachedResponse(for: request)?.data
        guard let data = data else {
            completion(.failure(.generic))
            return }
        completion(.success(data))
        
    }
}
