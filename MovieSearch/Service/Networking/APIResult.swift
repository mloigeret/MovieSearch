//
//  APIResult.swift
//  MovieSearch
//
//  Created by Manuel Loigeret on 2021-08-16.
//

import Foundation

enum ApiResult<T, U> where U: Error {
    case success(T)
    case failure(U)
}
