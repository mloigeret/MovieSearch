//
//  TMDBAPIClient.swift
//  MovieSearch
//
//  Created by Manuel Loigeret on 2021-08-16.
//

import Foundation

protocol TMDBAPIClientProtocol: GenericAPIClient {
    func fetchMovies(searchText: String,
                     page: Int,
                     completion: @escaping (ApiResult<PaginatedApiResponse<MovieSearchResult>?, APIError>) -> ())
    func fetchCredits(movieId: Int,
                      completion: @escaping (ApiResult<MovieCreditsResult?, APIError>) -> ())
    func fetchSimilarMovies(movieId: Int,
                            page: Int,
                            completion: @escaping (ApiResult<PaginatedApiResponse<MovieSearchResult>?, APIError>) -> ())
}

class TMDBAPIClient: TMDBAPIClientProtocol {

    private struct Constants {
        static let defaulHeaders = [HTTPHeader.contentType("application/json")]
    }
    
    internal let session: URLSession
    private var _fetchMoviesTask: URLSessionDataTask?
    private var _fetchCreditsTask: URLSessionDataTask?
    private var _fetchSimilarMoviesTask: URLSessionDataTask?
    
    static func instantiate() -> TMDBAPIClientProtocol {
        return TMDBAPIClient()
    }
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func fetchMovies(searchText: String,
                     page: Int,
                     completion: @escaping (ApiResult<PaginatedApiResponse<MovieSearchResult>?, APIError>) -> ()) {
        
        _fetchMoviesTask?.cancel()
        _fetchMoviesTask = nil
        
        let parameters = MovieSearchURLParameters(query: searchText, page: page)
        guard let request = TMDBEndpoint.search.createRequest(urlParameters: parameters,
                                                              method: .get,
                                                              headers: Constants.defaulHeaders) else {
            completion(.failure(.invalidRequest))
            return
        }
        
        _fetchMoviesTask = send(with: request, completion: completion)
    }
    
    func fetchCredits(movieId: Int,
                      completion: @escaping (ApiResult<MovieCreditsResult?, APIError>) -> ()) {
        
        _fetchCreditsTask?.cancel()
        _fetchCreditsTask = nil
        
        guard let request = TMDBEndpoint.credits(movieId: movieId).createRequest(urlParameters: MovieCreditsURLParameters(),
                                                                                 method: .get,
                                                                                 headers: Constants.defaulHeaders) else {
            completion(.failure(.invalidRequest))
            return
        }
        
        _fetchCreditsTask = send(with: request, completion: completion)
    }
    
    func fetchSimilarMovies(movieId: Int,
                            page: Int,
                            completion: @escaping (ApiResult<PaginatedApiResponse<MovieSearchResult>?, APIError>) -> ()) {
        
        _fetchSimilarMoviesTask?.cancel()
        _fetchSimilarMoviesTask = nil
        
        let parameters = SimilarMoviesURLParameters(page: page)
        guard let request = TMDBEndpoint.similars(movieId: movieId).createRequest(urlParameters: parameters,
                                                                                  method: .get,
                                                                                  headers: Constants.defaulHeaders) else {
            completion(.failure(.invalidRequest))
            return
        }
        _fetchSimilarMoviesTask = send(with: request, completion: completion)
    }
}
