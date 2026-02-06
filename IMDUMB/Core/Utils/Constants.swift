//
//  Constants.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation

// MARK: - Constants
struct Constants {
    
    // MARK: - App
    struct App {
        static let name = "IMDUMB"
        static let splashDelay: TimeInterval = 2.0
    }
    
    // MARK: - API
    struct API {
        static let baseURL = "https://api.themoviedb.org/3"
        static let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    }
    
    // MARK: - Storyboard IDs
    struct StoryboardID {
        static let splash = "SplashViewController"
        static let home = "HomeViewController"
        static let movieDetail = "MovieDetailViewController"
    }
    
    // MARK: - Cell IDs
    struct CellID {
        static let categoryCell = "CategoryCollectionViewCell"
        static let movieCell = "MovieTableViewCell"
        static let actorCell = "ActorCollectionViewCell"
    }
}
