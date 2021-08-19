//
//  SimilarMoviesURLParameters.swift
//  MovieSearch
//
//  Created by Manuel Loigeret on 2021-08-19.
//

import Foundation

struct SimilarMoviesURLParameters: APIURLParameters {
    let page: Int
    let apiKey = Configuration.TMDB.apiKey

    var parameters: [String : String] {
        get {
            return ["page": String(page),
                    "api_key": apiKey]
        }
    }
}
