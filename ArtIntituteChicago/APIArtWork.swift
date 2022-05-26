//
//  ArtWork.swift
//  ArtIntituteChicago
//
//  Created by Natalia Goyes on 8/04/22.
//

import Foundation

struct APIArtWork: Codable {
    let artWorks: ArtWork
                  
    private enum CodingKeys: String, CodingKey {
        case artWorks = "data"
    }
}

struct ArtWork: Codable {
    let id: Int
    let title: String
    let artist: String?
    let artistId: Int?
    let imageId: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, title, artist = "artist_title", artistId = "artist_id", imageId = "image_id"
    }
}

