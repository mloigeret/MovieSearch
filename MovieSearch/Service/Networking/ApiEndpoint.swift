//
//  ApiEndpoint.swift
//  MovieSearch
//
//  Created by Manuel Loigeret on 2021-08-16.
//

import Foundation

protocol APIEndpoint {
    var base: String { get }
    var path: String { get }
}

extension APIEndpoint {
    var urlComponents: URLComponents? {
        guard var components = URLComponents(string: base) else { return nil }
        components.path = path
        return components
    }

    func createRequest<T: Encodable>(bodyParameters: T,
                                     method: HTTPMethod,
                                     headers: [HTTPHeader]) -> URLRequest? {
        
        guard let components = urlComponents,
              let url = components.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(bodyParameters)
        } catch let error {
            print(APIError.postParametersEncodingFalure(description: "\(error)").customDescription)
            return nil
        }
        
        headers.forEach { request.addValue($0.header.value, forHTTPHeaderField: $0.header.field) }
        return request
    }
    
    func createRequest(urlParameters: APIURLParameters?,
                       method: HTTPMethod,
                       headers: [HTTPHeader]) -> URLRequest? {
        
        guard var components = urlComponents else {return nil}
        if let urlParameters = urlParameters {
            components.queryItems = urlParameters.parameters.map {
                URLQueryItem(name: $0, value: $1)
            }
        }
        
        guard let url = components.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        headers.forEach { request.addValue($0.header.value, forHTTPHeaderField: $0.header.field) }
        return request
    }
}
