//
//  SearchApiResponse.swift
//  MovieSearch
//
//  Created by Manuel Loigeret on 2021-08-16.
//

import Foundation

struct PaginatedApiResponse<T: Decodable>: Decodable {
    let page: Int
    let results: [T]
}
