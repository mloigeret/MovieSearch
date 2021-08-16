//
//  
//  HomeViewController.swift
//  MovieSearch
//
//  Created by Manuel Loigeret on 2021-08-16.
//
//

import UIKit

protocol HomeViewControllerProtocol: UIViewController {
    
}

class HomeViewController: UIViewController, HomeViewControllerProtocol {

    private var _viewModel: HomeViewModelProtocol
    
    static func instantiate(viewModel: HomeViewModelProtocol) -> HomeViewControllerProtocol {
        return HomeViewController(viewModel: viewModel)
    }
    
    init(viewModel: HomeViewModelProtocol) {
        _viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        _viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProperties()
        setupLayout()
        _viewModel.updateState()
    }

    private func setupProperties() {
        //title
        title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([

        ])
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func didUpdate(state: HomeViewState) {
        
    }
}