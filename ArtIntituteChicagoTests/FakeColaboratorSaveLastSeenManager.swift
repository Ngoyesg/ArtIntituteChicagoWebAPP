//
//  FakeColaboratorSaveLastSeenManager.swift
//  ArtIntituteChicagoTests
//
//  Created by Natalia Goyes on 16/05/22.
//

import Foundation
@testable import ArtIntituteChicago

class ColaboratorSaveLastSeenManager: SaveLastSeenManagerProtocol {
    var functionInvoked = false
    
    func saveArtWork(lastArtSeen: LastSeenArtWork?) {
        functionInvoked = true
    }
    
}
