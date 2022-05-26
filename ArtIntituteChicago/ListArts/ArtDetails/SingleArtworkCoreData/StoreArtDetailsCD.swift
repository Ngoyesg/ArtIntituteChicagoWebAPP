//
//  ArtDetailDataManager.swift
//  ArtIntituteChicago
//
//  Created by Natalia Goyes on 8/04/22.
//

import UIKit

protocol StoreArtDetailsCDProtocol: AnyObject {
    func storeArt(artworkToCreate: DetailedArtWork, onSuccess: (()->Void)?, onError: (()->Void)?)
}

class StoreArtDetailsCD: StoreArtDetailsCDProtocol {
    func storeArt(artworkToCreate: DetailedArtWork, onSuccess: (()->Void)?, onError: (()->Void)?){
        guard let delegate =  UIApplication.shared.delegate as? AppDelegate else {
            onError?()
            return
        }
        let context = delegate.coreDataManager.getViewContext()
        let entityDBArtwork = DBArtWork(context: context)
        entityDBArtwork.id = Int64(artworkToCreate.id)
        entityDBArtwork.title = artworkToCreate.title
        entityDBArtwork.artist = artworkToCreate.artist
        entityDBArtwork.image = artworkToCreate.image
        entityDBArtwork.lastSeen = artworkToCreate.lastSeenDate
        
        if let birthdate = artworkToCreate.artistBirthdate {
            entityDBArtwork.artistBirthdate = Int64(birthdate)
        }
        if let deathdate = artworkToCreate.artistDeathdate {
            entityDBArtwork.artistDeathdate = Int64(deathdate)
        }
        
        do {
            try context.save()
            print("artwork saved")
            onSuccess?()
        } catch {
            print(error.localizedDescription)
            onError?()
        }
    }
}
