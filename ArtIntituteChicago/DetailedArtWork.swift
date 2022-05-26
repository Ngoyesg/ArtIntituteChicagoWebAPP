//
//  LastSeenArtWork.swift
//  ArtIntituteChicago
//
//  Created by Natalia Goyes on 8/04/22.
//

import Foundation

struct LastSeenArtWork {
    let title: String
    let artist: String?
    let lastSeenDate: Date
}

struct DetailedArtWork {
    let id: Int
    let title: String
    let lastSeenDate: Date
    let artist: String?
    let artistBirthdate: Int?
    let artistDeathdate: Int?
    let image: Data?
}
