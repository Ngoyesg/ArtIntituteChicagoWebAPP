//
//  LastSeenSaver.swift
//  ArtIntituteChicago
//
//  Created by Natalia Goyes on 8/04/22.
//

import Foundation

protocol SaveLastSeenManagerProtocol: AnyObject {
    func saveArtWork(lastArtSeen: LastSeenArtWork?)
}

class SaveLastSeenManager: SaveLastSeenManagerProtocol {
    func saveArtWork(lastArtSeen: LastSeenArtWork?) {
        let store = UserDefaults.standard
        store.set(lastArtSeen?.title, forKey: UserDefaultConstant.titleSeen)
        store.set(lastArtSeen?.artist, forKey:  UserDefaultConstant.artistSeen)
        store.set(lastArtSeen?.lastSeenDate, forKey: UserDefaultConstant.dateSeen)
    }
}
