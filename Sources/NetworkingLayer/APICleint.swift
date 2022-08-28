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
    
    let cache = NSCache<NSString,NSData>()
}

extension APICleint: APICleintProtocol {
    
    public func send<ResponsType>(request: RequestProtocol, compeletion: @escaping (Result<ResponsType, CustomNetworkError>) -> Void) where ResponsType : Codable {
        
        let session = URLSession.shared
        let urlrequest = session.request(request)
        if request.cacheRequest ?? false , let requestFullURL = urlrequest.url?.absoluteString as? NSString {
            getCachedResponse(requestURL: requestFullURL) { result  in
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
                    self.callRequest(request: request, compeletion: compeletion)
                   
                }
            }
        }else{
            
            callRequest(request: request, compeletion: compeletion)
        }
        
    }
    private func callRequest<ResponsType>(request: RequestProtocol, compeletion: @escaping (Result<ResponsType, CustomNetworkError>) -> Void) where ResponsType : Codable {
        let session = URLSession.shared
        let urlrequest = session.request(request)
        let task = session.dataTask(with: urlrequest, completionHandler: { (data, response, _) in
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == .some(200) else {
                compeletion(Result.failure(.generic))
                return
            }
            guard let data = data  else {
                compeletion(Result.failure(.generic))
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(ResponsType.self, from: data)
                compeletion(Result.success(decodedData))
                if request.cacheRequest ?? false , let urlString = urlrequest.url?.absoluteString as? NSString  { self.cacheRequest(url: urlString,data: data) }
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
    func cacheRequest(url: NSString, data: Data) {
            cache.setObject(data as NSData, forKey: url)
    }
    func getCachedResponse(requestURL : NSString, completion: @escaping (Result<Data, CustomNetworkError>) -> Void) {
            if let cachedData = cache.object(forKey: requestURL) as? Data{
                completion(.success(cachedData))
            }else{
                completion(.failure(.generic))
            }
        
    }
}
