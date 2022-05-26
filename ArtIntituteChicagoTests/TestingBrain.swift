//
//  FakeBrain.swift
//  ArtIntituteChicagoTests
//
//  Created by Natalia Goyes on 16/05/22.
//

import Foundation
@testable import ArtIntituteChicago

class TestingListArtsBrain: ListArtsBrain {
    
    var fetchingDispatched = false
    
    override func fetchDownloadableArtWork() {
        fetchingDispatched = true
        super.fetchDownloadableArtWork()
    }
    
    override func updateArtWorks() {
        let artworkToUpdate = 
    }
    
}
