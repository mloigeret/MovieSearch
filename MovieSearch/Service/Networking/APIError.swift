//
//  APIError.swift
//  MovieSearch
//
//  Created by Manuel Loigeret on 2021-08-16.
//

import Foundation

enum APIError: Error {
    case cancelled
    case invalidRequest
    case invalidData
    case responseUnsuccessful(description: String)
    case requestFailed(description: String)
    case jsonConversionFailure(description: String)
    case postParametersEncodingFalure(description: String)
    
    var customDescription: String {
        switch self {
        case .cancelled: return "API Error: Cancelled"
        case .invalidRequest: return "API Error: Invalid request"
        case .invalidData: return "API Error: Invalid Data"
        case .responseUnsuccessful(let description): return "APIError: Response Unsuccessful status code: \(description)"
        case .requestFailed(let description): return "APIError: Request Failed: \(description)"
        case .jsonConversionFailure(let description): return "APIError: JSON Conversion Failure: \(description)"
        case .postParametersEncodingFalure(let description): return "APIError: post parameters failure: \(description)"
        }
    }
}
