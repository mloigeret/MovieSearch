//
//  MovieCreditsURLParameters.swift
//  MovieSearch
//
//  Created by Manuel Loigeret on 2021-08-18.
//

import Foundation

struct MovieCreditsURLParameters: APIURLParameters {
    let apiKey = Configuration.TMDB.apiKey

    var parameters: [String : String] {
        get {
            return ["api_key": apiKey]
        }
    }
}
