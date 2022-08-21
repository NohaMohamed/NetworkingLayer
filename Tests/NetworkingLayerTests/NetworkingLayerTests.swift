import XCTest
@testable import NetworkingLayer
import Foundation

class SpotifyRequestTests: XCTestCase {
    func test_fullPAth(){
        let mockRequest = MockRequest(baseURL: "https://www.google.com/",endPoint: "search")
        if let request = try? RequestMapper(mockRequest).asURLRequest(){
            XCTAssertEqual(request.url?.absoluteString, "https://www.google.com/search")
        }
        
    }
    func test_Request_Method(){
        let mockRequest = MockRequest()
        if let request = try? RequestMapper(mockRequest).asURLRequest(){
            XCTAssertEqual(request.httpMethod, mockRequest.method.rawValue)
        }
        
    }
    func test_Request_EmptyHeaders(){
        let mockRequest = MockRequest()
        if let request = try? RequestMapper(mockRequest).asURLRequest(){
            XCTAssertNil(request.allHTTPHeaderFields)
        }
    }
}
