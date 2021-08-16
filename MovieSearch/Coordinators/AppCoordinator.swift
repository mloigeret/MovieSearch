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
    
    static func instantiate(window: UIWindow) -> AppCordinatorProtocol {
        return AppCoordinator(window: window)
    }
    
    init(window: UIWindow) {
        _window = window
    }
    
    func start() {
        let viewModel = HomeViewModel.instantiate()
        let viewController = HomeViewController.instantiate(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.view.backgroundColor = .white
        _navigationController = navigationController
        _window.rootViewController = navigationController
        _window.makeKeyAndVisible()
    }
}