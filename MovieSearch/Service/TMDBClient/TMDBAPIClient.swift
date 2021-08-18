//
//  TMDBAPIClient.swift
//  MovieSearch
//
//  Created by Manuel Loigeret on 2021-08-16.
//

import Foundation

class TMDBAPIClient: GenericAPIClient {
    internal let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func fetchMovies(searchText: String, page: Int, completion: @escaping (ApiResult<SearchApiResponse<MovieSearchResult>?, APIError>) -> ()) {
        let parameters = MovieSearchURLParameters(query: searchText, page: page)
        
        guard let request = TMDBEndpoint.search.createRequest(urlParameters: parameters,
                                                              method: .get,
                                                              headers: [HTTPHeader.contentType("application/json")]) else {
            completion(.failure(.invalidRequest))
            return
        }
        
        send(with: request, completion: completion)
    }
}
