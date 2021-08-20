//
//  GenericApiClient.swift
//  MovieSearch
//
//  Created by Manuel Loigeret on 2021-08-11.
//

import Foundation

protocol GenericAPIClient {
    var session: URLSession { get }
    func send<T: Decodable>(with request: URLRequest, completion: @escaping (ApiResult<T, APIError>) -> Void) -> URLSessionDataTask
}

extension GenericAPIClient {
    func send<T: Decodable>(with request: URLRequest, completion: @escaping (ApiResult<T, APIError>) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                if let err = error as NSError?,
                   err.code == NSURLErrorCancelled {
                    completion(.failure(.cancelled))
                    return
                }
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
        return task
    }
}


