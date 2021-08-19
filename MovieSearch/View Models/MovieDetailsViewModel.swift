//
//  
//  MovieDetailsViewModel.swift
//  MovieSearch
//
//  Created by Manuel Loigeret on 2021-08-18.
//
//

import Foundation

protocol MovieDetailsViewModelProtocol {
    var delegate: MovieDetailsViewModelDelegate? { get set }
    var coordDelegate: MovieSelectionDelegate? { get set }
    func viewDidSetup()
    func willDisplaySimilarMovie(at index: Int)
    func didSelectSimilar(at index: Int)
}

protocol MovieDetailsViewModelDelegate: AnyObject {
    func initialUpdate(movie: MovieSearchResult)
    func didUpdate(credits: MovieCreditsResult)
    func didUpdate(similarMovies: [MovieSearchResult])
}

class MovieDetailsViewModel: MovieDetailsViewModelProtocol {
    private var _tmdbClient: TMDBAPIClientProtocol
    private var _isLoadingSimilars = true
    private let _movie: MovieSearchResult
    private var _currentPage = 1
    private var _similarMovies = [MovieSearchResult]()
    weak var delegate: MovieDetailsViewModelDelegate?
    weak var coordDelegate: MovieSelectionDelegate?
    
    static func instantiate(movie: MovieSearchResult,
                            tmdbClient: TMDBAPIClientProtocol) -> MovieDetailsViewModelProtocol {
        return MovieDetailsViewModel(movie: movie,
                                     tmdbClient: tmdbClient)
    }
    
    init(movie: MovieSearchResult,
         tmdbClient: TMDBAPIClientProtocol) {
        _movie = movie
        _tmdbClient = tmdbClient
    }
    
    func viewDidSetup() {
        delegate?.initialUpdate(movie: _movie)
        fetchCredits()
        fetchSimilarMovies()
    }
    
    func willDisplaySimilarMovie(at index: Int) {
        guard index == _similarMovies.count-5,
              _isLoadingSimilars == false
        else { return }
        _currentPage += 1
        fetchSimilarMovies()
    }
    
    func didSelectSimilar(at index: Int) {
        guard index < _similarMovies.count else { return }
        coordDelegate?.didSelect(movie: _similarMovies[index])
    }
    
    private func fetchCredits() {
        _tmdbClient.fetchCredits(movieId: _movie.id) { [weak self] result in
            switch result {
            case .failure(let error):
                print("Failed wit error = \(error)")
            case .success(let response):
                if let credits = response {
                    self?.delegate?.didUpdate(credits: credits)
                }
            }
        }
    }
    
    private func fetchSimilarMovies() {
        _isLoadingSimilars = true
        _tmdbClient.fetchSimilarMovies(movieId: _movie.id, page: _currentPage) { [weak self] result in
            switch result {
            case .failure(let error):
                print("Failed wit error = \(error)")
            case .success(let response):
                if let results = response?.results {
                    self?._similarMovies.append(contentsOf: results)
                }
            }
            self?._isLoadingSimilars = false
            if let similarMovies = self?._similarMovies {
                self?.delegate?.didUpdate(similarMovies: similarMovies)
            }
        }
    }
}
