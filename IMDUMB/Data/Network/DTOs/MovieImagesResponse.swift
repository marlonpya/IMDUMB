//
//  MovieImagesResponse.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation

// MARK: - Movie Images Response
struct MovieImagesResponse: Codable {
    let id: Int
    let backdrops: [ImageDTO]?
    let posters: [ImageDTO]?
    let logos: [ImageDTO]?
}

// MARK: - Image DTO
struct ImageDTO: Codable {
    let filePath: String
    let width: Int
    let height: Int
    let aspectRatio: Double
    let voteAverage: Double?
    let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case width, height
        case filePath = "file_path"
        case aspectRatio = "aspect_ratio"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
