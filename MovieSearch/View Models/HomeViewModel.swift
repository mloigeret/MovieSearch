//
//  
//  HomeViewModel.swift
//  MovieSearch
//
//  Created by Manuel Loigeret on 2021-08-16.
//
//

import Foundation

struct HomeViewState {
    
}

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    func updateState()
}

protocol HomeViewModelDelegate: AnyObject {
    func didUpdate(state: HomeViewState)
}

class HomeViewModel: HomeViewModelProtocol {
    
    weak var delegate: HomeViewModelDelegate?
    
    static func instantiate() -> HomeViewModelProtocol {
        return HomeViewModel()
    }
    
    func updateState() {
        let state = HomeViewState()
        //.....
        delegate?.didUpdate(state: state)
    }
}
