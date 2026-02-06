//
//  SplashViewController.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import UIKit

// MARK: - SplashViewProtocol
/// SOLID: SRP - La vista solo se encarga de mostrar/ocultar elementos visuales
protocol SplashViewProtocol: AnyObject {
    func displayLoading()
    func dismissLoading()
    func navigateToHome()
    func displayWelcomeMessage(_ message: String)
    func displayError(_ message: String)
}

// MARK: - SplashViewController
class SplashViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    var presenter: SplashPresenterProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Setup
    private func setupUI() {
        titleLabel.text = Constants.App.name
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textColor = .white
        
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.15, alpha: 1.0)
    }
}

// MARK: - SplashViewProtocol Implementation
extension SplashViewController: SplashViewProtocol {
    
    func displayLoading() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    func dismissLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func navigateToHome() {
        let homeVC = HomeViewController.loadFromNib()
        let dataStore = DataStoreFactory.makeDataStore()
        let repository = MovieRepositoryImpl(dataStore: dataStore)
        let useCase = GetCategoriesUseCase(repository: repository)
        let presenter = HomePresenter(view: homeVC, interactor: HomeInteractor(useCase: useCase))
        homeVC.presenter = presenter
        
        let navigationController = UINavigationController(rootViewController: homeVC)
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true) {
            // Limpiar el presenter para evitar retain cycles
            self.presenter = nil
        }
    }
    
    func displayWelcomeMessage(_ message: String) {
        showAlert(
            title: "¡Bienvenido!",
            message: message,
            actions: [
                UIAlertAction(title: "Comenzar", style: .default) { [weak self] _ in
                    self?.navigateToHome()
                }
            ]
        )
    }
    
    func displayError(_ message: String) {
        showAlert(
            title: "Error",
            message: message,
            actions: [
                UIAlertAction(title: "Reintentar", style: .default) { [weak self] _ in
                    self?.presenter?.viewDidLoad()
                }
            ]
        )
    }
}
