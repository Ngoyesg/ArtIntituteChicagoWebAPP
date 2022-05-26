//
//  LastSeenManager.swift
//  ArtIntituteChicago
//
//  Created by Natalia Goyes on 8/04/22.
//

import Foundation

protocol GetLastSeenManagerProtocol: AnyObject {
    func getArtWork() -> LastSeenArtWork?
}

class GetLastSeenManager: GetLastSeenManagerProtocol {
    func getArtWork() -> LastSeenArtWork? {
        let store = UserDefaults.standard
        let title = store.value(forKey: UserDefaultConstant.titleSeen) as? String
        let artist = store.value(forKey: UserDefaultConstant.artistSeen) as? String
        let dateSeen = store.value(forKey: UserDefaultConstant.dateSeen) as? Date
        
        var lastSeenArt: LastSeenArtWork? = nil
        if let title = title, let artist = artist, let dateSeen = dateSeen {
            lastSeenArt = LastSeenArtWork(title: title, artist: artist, lastSeenDate: dateSeen)
        }
        
        return lastSeenArt
    }
}
