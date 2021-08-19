//
//  
//  HomeViewController.swift
//  MovieSearch
//
//  Created by Manuel Loigeret on 2021-08-16.
//
//

import UIKit

protocol HomeViewControllerProtocol: UITableViewController {
    
}

class HomeViewController: UITableViewController, HomeViewControllerProtocol {
    
    private struct Constants {
        static let movieSearchCellIdentifier = "moviesearchcellidentifier"
    }
    
    private var _viewModel: HomeViewModelProtocol
    private let _searchController = UISearchController(searchResultsController: nil)
    private var _movieSearchResults = [MovieSearchResult]()
    
    static func instantiate(viewModel: HomeViewModelProtocol) -> HomeViewControllerProtocol {
        return HomeViewController(viewModel: viewModel)
    }
    
    init(viewModel: HomeViewModelProtocol) {
        _viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        _viewModel.vcDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProperties()
    }

    private func setupProperties() {
        //title
        title = "Movie Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //search
        _searchController.searchBar.placeholder = "Search for movies"
        _searchController.searchBar.returnKeyType = .done
        _searchController.obscuresBackgroundDuringPresentation = false
        _searchController.searchBar.delegate = self
        navigationItem.searchController = _searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        //table
        tableView.register(MovieTableViewCell.self,
                           forCellReuseIdentifier: Constants.movieSearchCellIdentifier)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
    }
}

extension HomeViewController: HomeViewModelVCDelegate {
    func didUpdate(movies: [MovieSearchResult]) {
        DispatchQueue.main.async {
            self._movieSearchResults = movies
            self.tableView.reloadData()
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.search(text:)), object: searchBar)
        perform(#selector(self.search(text:)), with: searchText, afterDelay: 0.5)
    }
    
    @objc func search(text: String) {
        _viewModel.search(text: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        _viewModel.search(text: "")
    }
}

extension HomeViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _movieSearchResults.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.movieSearchCellIdentifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(movie: _movieSearchResults[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        _viewModel.willDisplayItem(at: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        _viewModel.didSelectItem(at: indexPath.row)
    }
}
