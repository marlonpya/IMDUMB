//
//  HomeViewController.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import UIKit

// MARK: - HomeViewProtocol
/// SOLID: SRP - La vista solo se encarga de mostrar/ocultar elementos
// MARK: - HomeViewProtocol
protocol HomeViewProtocol: AnyObject {
    func displayLoading()
    func dismissLoading()
    func displayCategories()
    func displayError(_ error: Error)
}

// MARK: - HomeViewController
class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    var presenter: HomePresenterProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Categorías"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        
        // Registrar celda custom
        let nib = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier)
        
        // Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        collectionView.collectionViewLayout = layout
    }
}

extension HomeViewController: HomeViewProtocol {
    
    func displayLoading() {
        showLoading()
    }
    
    func dismissLoading() {
        hideLoading()
    }
    
    func displayCategories() {
        collectionView.reloadData()
    }
    
    func displayError(_ error: Error) {
        showError(error)
    }
}

// MARK: - UICollectionView DataSource
extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.numberOfCategories() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let category = presenter?.categoryAtIndex(indexPath.row) {
            cell.configure(with: category, delegate: self)
        }
        
        return cell
    }
}

// MARK: - UICollectionView Delegate
extension HomeViewController: UICollectionViewDelegate {
    // Implementación opcional para eventos de tap en categorías
}

// MARK: - UICollectionView DelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height: CGFloat = 240 // Altura para contener el TableView con películas
        return CGSize(width: width, height: height)
    }
}

// MARK: - CategoryCellDelegate
extension HomeViewController: CategoryCellDelegate {
    
    func didSelectMovie(_ movie: Movie) {
        presenter?.didSelectMovie(movie)
        let detailVC = MovieDetailViewController.loadFromNib()
        let dataStore = DataStoreFactory.makeDataStore()
        let repository = MovieRepositoryImpl(dataStore: dataStore)
        let useCase = GetMovieDetailUseCase(repository: repository)
        let interactor = MovieDetailInteractor(useCase: useCase, movieId: movie.id)
        let presenter = MovieDetailPresenter(view: detailVC, interactor: interactor)
        
        detailVC.presenter = presenter
        
        // Push al navigation controller
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
