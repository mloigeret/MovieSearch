//
//  MovieSelectionDelegate.swift
//  MovieSearch
//
//  Created by Manuel Loigeret on 2021-08-19.
//

import Foundation

protocol MovieSelectionDelegate: AnyObject {
    func didSelect(movie: MovieSearchResult)
}
