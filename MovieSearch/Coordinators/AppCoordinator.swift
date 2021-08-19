//
//  
//  AppCoordinator.swift
//  MovieSearch
//
//  Created by Manuel Loigeret on 2021-08-16.
//
//

import UIKit

protocol AppCordinatorProtocol: Coordinator {}

class AppCoordinator: AppCordinatorProtocol {
    private let _window: UIWindow
    private var _navigationController: UINavigationController?
    private let _tmdbClient = TMDBAPIClient.instantiate()
    
    static func instantiate(window: UIWindow) -> AppCordinatorProtocol {
        return AppCoordinator(window: window)
    }
    
    init(window: UIWindow) {
        _window = window
    }
    
    func start() {
        var vm = HomeViewModel.instantiate(tmdbClient: _tmdbClient)
        vm.coordDelegate = self
        let vc = HomeViewController.instantiate(viewModel: vm)
        let nc = UINavigationController(rootViewController: vc)
        _navigationController = nc
        _window.rootViewController = nc
        _window.makeKeyAndVisible()
    }
    
    func showMovieDetails(movie: MovieSearchResult) {
        var vm = MovieDetailsViewModel.instantiate(movie: movie, tmdbClient: _tmdbClient)
        vm.coordDelegate = self
        let vc = MovieDetailsViewController(viewModel: vm)
        _navigationController?.show(vc, sender: self)
    }
}

extension AppCoordinator: MovieSelectionDelegate {
    func didSelect(movie: MovieSearchResult) {
        showMovieDetails(movie: movie)
    }
}
