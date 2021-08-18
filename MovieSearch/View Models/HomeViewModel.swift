//
//  
//  HomeViewModel.swift
//  MovieSearch
//
//  Created by Manuel Loigeret on 2021-08-16.
//
//

import Foundation

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    func search(text: String)
    func willDisplayItem(at index: Int)
}

protocol HomeViewModelDelegate: AnyObject {
    func didUpdate(movies: [MovieSearchResult])
}

class HomeViewModel: HomeViewModelProtocol {
    
    private var _tmdbClient = TMDBAPIClient()
    private var _currentSearchText: String? = nil
    private var _currentPage: Int = 1
    private var _currentMovies = [MovieSearchResult]()
    private var _isLoading = false
    
    weak var delegate: HomeViewModelDelegate?
    
    static func instantiate() -> HomeViewModelProtocol {
        return HomeViewModel()
    }
    
    func search(text: String) {
        _currentMovies = []
        _currentPage = 1
        if text.trimmingCharacters(in: .whitespaces) != "" {
            _currentSearchText = text
            fetchMovies()
        }
        else {
            _currentSearchText = nil
            delegate?.didUpdate(movies: _currentMovies)
        }
    }
    
    func fetchMovies() {
        guard let text = _currentSearchText else { return }
        _isLoading = true
        _tmdbClient.fetchMovies(searchText: text, page : _currentPage) { [unowned self] result in
            switch result {
            case .failure(let error):
                print("Failed wit error = \(error)")
            case .success(let response):
                if let results = response?.results {
                    _currentMovies.append(contentsOf: results)
                }
            }
            _isLoading = false
            delegate?.didUpdate(movies: _currentMovies)
        }
    }
    
    func willDisplayItem(at index: Int) {
        guard index == _currentMovies.count-5,
              _isLoading == false
        else { return }
        _currentPage += 1
        fetchMovies()
    }
}
