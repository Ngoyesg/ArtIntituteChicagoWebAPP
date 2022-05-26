//
//  FakeColaboratorGetLastSeenManager.swift
//  ArtIntituteChicagoTests
//
//  Created by Natalia Goyes on 16/05/22.
//

import Foundation
@testable import ArtIntituteChicago

class ColaboratorGetLastSeenManager: GetLastSeenManagerProtocol {
   
    func getArtWork() -> LastSeenArtWork? {
        return LastSeenArtWork(title: "DummyTitle", artist: "DummyArtist", lastSeenDate: Date())
    }
    
}
