//
//  AppConfig.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation

// MARK: - AppConfig Entity
/// Entidad que representa la configuración de la aplicación
struct AppConfig {
    let welcomeMessage: String
    let apiBaseURL: String
    let enableFeatureX: Bool
    
    init(
        welcomeMessage: String = "Bienvenido a IMDUMB",
        apiBaseURL: String = "https://api.themoviedb.org/3",
        enableFeatureX: Bool = true
    ) {
        self.welcomeMessage = welcomeMessage
        self.apiBaseURL = apiBaseURL
        self.enableFeatureX = enableFeatureX
    }
}
