//
//  
//  MovieDetailsViewController.swift
//  MovieSearch
//
//  Created by Manuel Loigeret on 2021-08-18.
//
//

import UIKit

protocol MovieDetailsViewControllerProtocol: UIViewController {}

class MovieDetailsViewController: UIViewController, MovieDetailsViewControllerProtocol {

    private struct Constants {
        static let cellIdentifier = "similarCellIdentifier"
        static let collectionCellWidth: CGFloat = 150
        static let collectionCellHeight: CGFloat = 300
    }

    private let _scrollView = UIScrollView()
    private let _scrollViewContent = UIView()
    private let _movieDetailsView = MovieDetailsView()
    private let _similarCollectionView: UICollectionView
    private var _similarCollectionRegistration: UICollectionView.CellRegistration<SimilarCollectionViewCell,MovieSearchResult>?
    
    private var _viewModel: MovieDetailsViewModelProtocol
    private var _similarMovies: [MovieSearchResult]?
    
    static func instantiate(viewModel: MovieDetailsViewModelProtocol) -> MovieDetailsViewControllerProtocol {
        return MovieDetailsViewController(viewModel: viewModel)
    }
    
    private static func setupFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: Constants.collectionCellWidth,
                                     height: Constants.collectionCellHeight)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        return flowLayout
    }
    
    init(viewModel: MovieDetailsViewModelProtocol) {
        _viewModel = viewModel
        _similarCollectionView = UICollectionView(frame: CGRect.zero,
                                                  collectionViewLayout: MovieDetailsViewController.setupFlowLayout())
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
        _viewModel.viewDidSetup()
    }

    private func setupProperties() {
        
        //background
        view.backgroundColor = .systemBackground
        
        //title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //collection
        _similarCollectionRegistration = UICollectionView.CellRegistration<SimilarCollectionViewCell,MovieSearchResult> { (cell, indexPath, movie) in
            cell.configure(movieSearchResult: movie)
        }
        _similarCollectionView.dataSource = self
        _similarCollectionView.delegate = self
    }
    
    private func setupLayout() {
        _scrollView.translatesAutoresizingMaskIntoConstraints = false
        _scrollViewContent.translatesAutoresizingMaskIntoConstraints = false
        _movieDetailsView.translatesAutoresizingMaskIntoConstraints = false
        _similarCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(_scrollView)
        _scrollView.addSubview(_scrollViewContent)
        _scrollViewContent.addSubview(_movieDetailsView)
        _scrollViewContent.addSubview(_similarCollectionView)
        
        let scrollViewContentHeightConstraint = _scrollViewContent.heightAnchor.constraint(greaterThanOrEqualTo: _scrollView.heightAnchor)
        scrollViewContentHeightConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            _scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            _scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            _scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            _scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            _scrollViewContent.topAnchor.constraint(equalTo: _scrollView.topAnchor),
            _scrollViewContent.leftAnchor.constraint(equalTo: _scrollView.leftAnchor),
            _scrollViewContent.rightAnchor.constraint(equalTo: _scrollView.rightAnchor),
            _scrollViewContent.bottomAnchor.constraint(equalTo: _scrollView.bottomAnchor),
            _scrollViewContent.widthAnchor.constraint(equalTo: _scrollView.widthAnchor),
            scrollViewContentHeightConstraint,
            
            _movieDetailsView.topAnchor.constraint(equalTo: _scrollViewContent.topAnchor),
            _movieDetailsView.leftAnchor.constraint(equalTo: _scrollViewContent.leftAnchor),
            _movieDetailsView.rightAnchor.constraint(equalTo: _scrollViewContent.rightAnchor),
            _movieDetailsView.heightAnchor.constraint(equalToConstant: 300),
            
            _similarCollectionView.topAnchor.constraint(equalTo: _movieDetailsView.bottomAnchor),
            _similarCollectionView.leftAnchor.constraint(equalTo: _scrollViewContent.leftAnchor),
            _similarCollectionView.rightAnchor.constraint(equalTo: _scrollViewContent.rightAnchor),
            _similarCollectionView.bottomAnchor.constraint(equalTo: _scrollViewContent.bottomAnchor),
            _similarCollectionView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}

extension MovieDetailsViewController: MovieDetailsViewModelDelegate {
    func initialUpdate(movie: MovieSearchResult) {
        DispatchQueue.main.async {
            self.title = movie.title
            self._movieDetailsView.configure(with: movie)
        }
    }
    
    func didUpdate(credits: MovieCreditsResult) {
        DispatchQueue.main.async {
            self._movieDetailsView.configure(with: credits)
        }
    }
    
    func didUpdate(similarMovies: [MovieSearchResult]) {
        DispatchQueue.main.async {
            self._similarMovies = similarMovies
            self._similarCollectionView.reloadData()
        }
    }
}

extension MovieDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _similarMovies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let registration = _similarCollectionRegistration,
              let similarMovies = _similarMovies else {
            return UICollectionViewCell()
        }
        return _similarCollectionView.dequeueConfiguredReusableCell(using: registration,
                                                                              for: indexPath,
                                                                              item: similarMovies[indexPath.row])
    }
}

extension MovieDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        _viewModel.willDisplaySimilarMovie(at: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _viewModel.didSelectSimilar(at: indexPath.row)
    }
}
