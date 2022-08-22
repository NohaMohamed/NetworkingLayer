//
//  NetworkError.swift
//  Networking
//
//  Created by Noha Mohamed on 18/08/2022.
//

import Foundation

public enum CustomNetworkError: Error, LocalizedError {
    
    init(error: Error) {
        self = .unknowen(Localization.string(for: .errorMessageGeneric))
    }
    
    case canNotMapRequest
    case canNotDecodeObject
    case unknowen(String?)
    case generic
    
    public var localizedDescription: String {
        switch self {
        case .canNotMapRequest:
            return Localization.string(for: .errorMessageCanNotSendRequest)
        case .canNotDecodeObject:
            return Localization.string(for: .errorMessageCanNotReadData)
        case .generic:
            return Localization.string(for: .errorMessageGeneric)
        case .unknowen(let message):
            return message ?? Localization.string(for: .errorMessageGeneric)
            
        }
    }

}
