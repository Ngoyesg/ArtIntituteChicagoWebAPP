//
//  DownloadbleArtWork.swift
//  ArtIntituteChicago
//
//  Created by Natalia Goyes on 8/04/22.
//

import Foundation

struct APIPagination: Codable {
    let artWorks: [ArtWork]
    let config: ArtWorkConfig
    
    private enum CodingKeys: String, CodingKey {
        case artWorks = "data", config
    }
    
}
struct ArtWorkConfig: Codable {
    let baseImageURL: String?
    
    private enum CodingKeys: String, CodingKey {
        case baseImageURL = "iiif_url"
    }
}
