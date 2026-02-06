//
//  MovieCreditsResponse.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation

// MARK: - Movie Credits Response
struct MovieCreditsResponse: Codable {
    let id: Int
    let cast: [CastDTO]
    let crew: [CrewDTO]?
}

// MARK: - Cast DTO
struct CastDTO: Codable {
    let id: Int
    let name: String
    let character: String?
    let profilePath: String?
    let order: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name, character, order
        case profilePath = "profile_path"
    }
}

// MARK: - Crew DTO
struct CrewDTO: Codable {
    let id: Int
    let name: String
    let job: String?
    let department: String?
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, job, department
        case profilePath = "profile_path"
    }
}
