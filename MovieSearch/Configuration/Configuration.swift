//
//  Configuration.swift
//  MovieSearch
//
//  Created by Manuel Loigeret on 2021-08-16.
//

import Foundation

struct Configuration {
        struct TMDB {
            static let apiKey = ApiKeys.tmdbApiKey
            static let baseUrl = "https://api.themoviedb.org"
            static let imgBaseUrl = "https://image.tmdb.org/t/p/w500"
        }
}
