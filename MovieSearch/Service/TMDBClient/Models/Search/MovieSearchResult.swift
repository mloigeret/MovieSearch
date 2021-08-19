//
//  MovieSearchResult.swift
//  MovieSearch
//
//  Created by Manuel Loigeret on 2021-08-16.
//

import Foundation

struct MovieSearchResult: Decodable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    
    var fullPosterPath: String? {
        get {
            guard let posterPath = posterPath else { return nil }
            return Configuration.TMDB.imgBaseUrl + posterPath
        }
    }
}
