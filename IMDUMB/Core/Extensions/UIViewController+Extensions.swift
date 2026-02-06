//
//  UIViewController+Extensions.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import UIKit

// MARK: - UIViewController Extensions
extension UIViewController {
    
    // MARK: - Loading Indicator
    private static var loadingViewTag = 999999
    
    func showLoading() {
        // Evitar mostrar múltiples loading views
        if view.viewWithTag(UIViewController.loadingViewTag) != nil {
            return
        }
        
        let loadingView = UIView(frame: view.bounds)
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        loadingView.tag = UIViewController.loadingViewTag
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.center = loadingView.center
        activityIndicator.startAnimating()
        
        loadingView.addSubview(activityIndicator)
        view.addSubview(loadingView)
    }
    
    func hideLoading() {
        view.viewWithTag(UIViewController.loadingViewTag)?.removeFromSuperview()
    }
    
    // MARK: - Alerts
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    
    // Versión con acciones personalizadas
    func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        present(alert, animated: true)
    }
    
    func showError(_ error: Error) {
        showAlert(title: "Error", message: error.localizedDescription)
    }
    
    // MARK: - XIB Loading
    static func loadFromNib() -> Self {
        return Self(nibName: String(describing: self), bundle: nil)
    }
}
