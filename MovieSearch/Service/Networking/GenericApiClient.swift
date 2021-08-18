//
//  GenericApiClient.swift
//  MovieSearch
//
//  Created by Manuel Loigeret on 2021-08-11.
//

import Foundation

protocol GenericAPIClient {
    var session: URLSession { get }
    func send<T: Decodable>(with request: URLRequest, completion: @escaping (ApiResult<T, APIError>) -> Void)
}

extension GenericAPIClient {
    func send<T: Decodable>(with request: URLRequest, completion: @escaping (ApiResult<T, APIError>) -> Void) {
        let task = session.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed(description: error?.localizedDescription ?? "No description")))
                return
            }
            guard httpResponse.statusCode == 200  else {
                completion(.failure(.responseUnsuccessful(description: "\(httpResponse.statusCode)")))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let value = try decoder.decode(T.self, from: data)
                completion(.success(value))
            }
            catch let err {
                completion(.failure(.jsonConversionFailure(description: "\(err.localizedDescription)")))
            }
        }
        task .resume()
    }
}


