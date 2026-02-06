//
//  SplashPresenter.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation

// MARK: - SplashPresenterProtocol
/// SOLID: SRP - El presenter solo coordina la vista y el interactor
protocol SplashPresenterProtocol {
    func viewDidLoad()
    func configDidLoad()
}

// MARK: - SplashPresenter
class SplashPresenter: SplashPresenterProtocol {
    
    // MARK: - Properties
    weak var view: SplashViewProtocol?
    private let interactor: SplashInteractorProtocol
    
    // MARK: - Init
    // SOLID: DIP - Depende de abstracciones (protocols), no de implementaciones concretas
    init(view: SplashViewProtocol, interactor: SplashInteractorProtocol) {
        self.view = view
        self.interactor = interactor
    }
    
    // MARK: - SplashPresenterProtocol
    func viewDidLoad() {
        view?.displayLoading()
        
        interactor.loadConfig { [weak self] config in
            print("[SplashPresenter] Config loaded: \(config.welcomeMessage)")
            self?.configDidLoad()
        }
    }
    
    func configDidLoad() {
        if AppConfigurationManager.shared.maintenanceMode {
            print("[SplashPresenter] Maintenance mode is active")
            
            DispatchQueue.main.async { [weak self] in
                self?.view?.dismissLoading()
                self?.view?.displayError("La aplicación está en mantenimiento. Por favor intenta más tarde.")
            }
            return
        }
        
        // Simular delay de splash screen
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.App.splashDelay) { [weak self] in
            self?.view?.dismissLoading()
            let welcomeMsg = AppConfigurationManager.shared.welcomeMessage
            print("[SplashPresenter] Showing welcome message: \(welcomeMsg)")
            self?.view?.displayWelcomeMessage(welcomeMsg)
        }
    }
}
