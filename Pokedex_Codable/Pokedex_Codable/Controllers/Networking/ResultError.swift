//
//  ResultError.swift
//  Pokedex_Codable
//
//  Created by Esther on 10/11/22.
//

import Foundation
enum ResultError: LocalizedError {
    
    case invalidURL(String)
    case thrownError(Error)
    case noData
    case unableToDecode
    case noUser
    
    
    var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return "Unable to reach the server. Please try again.\(url)"
        case .thrownError(let error):
            return "Error: \(error.localizedDescription) -> \(error)"
        case .noData:
            return "The server responded with no data. Please try again."
        case .unableToDecode:
            return "The server responded with bad data. Please try again."
        case .noUser:
            return "Do you need to sign in?"
        }
    }
}
