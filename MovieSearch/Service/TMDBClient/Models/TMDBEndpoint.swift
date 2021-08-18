//
//  TMDBEndpoint.swift
//  MovieSearch
//
//  Created by Manuel Loigeret on 2021-08-16.
//

import Foundation

enum TMDBEndpoint {
    case search
}

extension TMDBEndpoint: APIEndpoint {
    var base: String {
        return Configuration.TMDB.baseUrl
    }
    
    var path: String {
        switch self {
        case .search: return "/3/search/movie"
        }
    }
}
