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
    var vcDelegate: HomeViewModelVCDelegate? { get set }
    var coordDelegate: MovieSelectionDelegate? { get set }
    func search(text: String)
    func willDisplayItem(at index: Int)
    func didSelectItem(at index: Int)
}

protocol HomeViewModelVCDelegate: AnyObject {
    func didUpdate(movies: [MovieSearchResult])
}

class HomeViewModel: HomeViewModelProtocol {
    
    private let _tmdbClient: TMDBAPIClientProtocol
    private var _currentSearchText: String? = nil
    private var _currentPage: Int = 1
    private var _currentMovies = [MovieSearchResult]()
    private var _isLoading = false
    
    weak var vcDelegate: HomeViewModelVCDelegate?
    weak var coordDelegate: MovieSelectionDelegate?
    
    static func instantiate(tmdbClient: TMDBAPIClientProtocol) -> HomeViewModelProtocol {
        return HomeViewModel(tmdbClient: tmdbClient)
    }
    
    init(tmdbClient: TMDBAPIClientProtocol) {
        _tmdbClient = tmdbClient
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
            vcDelegate?.didUpdate(movies: _currentMovies)
        }
    }
    
    func fetchMovies() {
        guard let text = _currentSearchText else { return }
        _isLoading = true
        _tmdbClient.fetchMovies(searchText: text, page : _currentPage) { [weak self] result in
            switch result {
            case .failure(let error):
                if error.customDescription == APIError.cancelled.customDescription {
                    return
                }
                print("Failed with error = \(error)")
                
            case .success(let response):
                if let results = response?.results {
                    self?._currentMovies.append(contentsOf: results)
                }
            }
            self?._isLoading = false
            if let movies = self?._currentMovies {
                self?.vcDelegate?.didUpdate(movies: movies)
            }
        }
    }
    
    func willDisplayItem(at index: Int) {
        guard index == _currentMovies.count-5,
              _isLoading == false
        else { return }
        _currentPage += 1
        fetchMovies()
    }
    
    func didSelectItem(at index: Int) {
        guard index < _currentMovies.count else { return }
        coordDelegate?.didSelect(movie: _currentMovies[index])
    }
}
