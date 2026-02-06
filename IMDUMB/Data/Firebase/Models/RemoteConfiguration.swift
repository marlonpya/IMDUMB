//
//  RemoteConfiguration.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation

// MARK: - Remote Configuration
/// Configuración remota desde Firebase Remote Config
struct RemoteConfiguration: Codable {
    let welcomeMessage: String
    let apiTimeout: Int
    let recommendationsEnabled: Bool
    let maintenanceMode: Bool
    let categoriesLimit: Int
    let moviesPerCategory: Int
    
    // Valores por defecto
    static let `default` = RemoteConfiguration(
        welcomeMessage: "Bienvenido a IMDUMB",
        apiTimeout: 30,
        recommendationsEnabled: true,
        maintenanceMode: false,
        categoriesLimit: 5,
        moviesPerCategory: 10
    )
    
    // Keys para Firebase Remote Config
    enum ConfigKey: String {
        case welcomeMessage = "welcome_message"
        case apiTimeout = "api_timeout"
        case recommendationsEnabled = "recommendations_enabled"
        case maintenanceMode = "maintenance_mode"
        case categoriesLimit = "categories_limit"
        case moviesPerCategory = "movies_per_category"
    }
}
