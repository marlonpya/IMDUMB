//
//  DataStoreFactory.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation

// MARK: - Environment
enum Environment: String {
    case dev = "DEV"
    case qa = "QA"
    case production = "PRODUCTION"
    
    static var current: Environment {
        #if DEV
        print("   🔍 Compiler flag detected: DEV")
        return .dev
        #elseif QA
        print("   🔍 Compiler flag detected: QA")
        return .qa
        #else
        print("   🔍 Compiler flag detected: PRODUCTION (or none)")
        return .production
        #endif
    }
    
    var description: String {
        switch self {
        case .dev: return "Development (Mock Data)"
        case .qa: return "QA (Firebase + TMDB API)"
        case .production: return "Production (Firebase + TMDB API)"
        }
    }
}

// MARK: - Data Store Type
enum DataStoreType {
    case mock      // Datos hardcodeados locales
    case remote    // TMDB API con Alamofire
    case firebase  // Firebase Remote Config + TMDB API
    
    var description: String {
        switch self {
        case .mock: return "MockDataStore (local data)"
        case .remote: return "RemoteMovieDataStore (TMDB API)"
        case .firebase: return "FirebaseDataStore (Remote Config + TMDB API)"
        }
    }
}

// MARK: - Data Store Factory
class DataStoreFactory {
    
    /// Tipo de DataStore actual (configurado automáticamente por el entorno)
    static var currentType: DataStoreType = {
        let environment = Environment.current
        
        
        let dataStoreType: DataStoreType
        
        switch environment {
        case .dev:
            // DEV: Usar datos mock para desarrollo rápido sin dependencias
            dataStoreType = .mock
            
        case .qa:
            // QA y PRODUCTION: Ambos usan Firebase Remote Config + TMDB API
            dataStoreType = .firebase
            
        case .production:
            // PRODUCTION: Usar Firebase Remote Config + TMDB API
            dataStoreType = .firebase
        }
        
        
        return dataStoreType
    }()
    
    /// Crea el DataStore según el tipo configurado
    static func makeDataStore() -> DataStore {
        return makeDataStore(type: currentType)
    }
    
    /// Crea un DataStore específico
    static func makeDataStore(type: DataStoreType) -> DataStore {
        
        switch type {
        case .mock:
            return MockDataStore()
            
        case .remote:
            return RemoteMovieDataStore()
            
        case .firebase:
            return FirebaseDataStore()
        }
    }
    
    /// Información del entorno actual
    static func printEnvironmentInfo() {
        let env = Environment.current
        print("Target Environment: \(env.rawValue)")
        print("Description: \(env.description)")
        print("DataStore Type: \(currentType.description)")
    }
    
    /// Cambia el tipo de DataStore en tiempo de ejecución (útil para testing)
    static func setDataStoreType(_ type: DataStoreType) {
        currentType = type
    }
}
