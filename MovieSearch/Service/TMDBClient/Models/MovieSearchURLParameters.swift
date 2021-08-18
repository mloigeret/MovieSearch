//
//  MovieSearchURLParameters.swift
//  MovieSearch
//
//  Created by Manuel Loigeret on 2021-08-16.
//

import Foundation

struct MovieSearchURLParameters: APIURLParameters {
    let query: String
    let page: Int
    let apiKey = Configuration.TMDB.apiKey

    var parameters: [String : String] {
        get {
            return ["query": query,
                    "page": String(page),
                    "api_key": apiKey]
        }
    }
}
