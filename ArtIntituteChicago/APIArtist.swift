//
//  Artist.swift
//  ArtIntituteChicago
//
//  Created by Natalia Goyes on 8/04/22.
//

import Foundation

struct APIArtist: Codable {
    let artistInfo: Artist
    
    private enum CodingKeys: String, CodingKey {
        case artistInfo = "data"
    }
}

struct Artist: Codable {
    let id: Int
    let title: String?
    let birthDate: Int?
    let deathDate: Int?
    
    private enum CodingKeys: String, CodingKey {
        case id, title, birthDate = "birth_date", deathDate = "death_date"
    }
}
