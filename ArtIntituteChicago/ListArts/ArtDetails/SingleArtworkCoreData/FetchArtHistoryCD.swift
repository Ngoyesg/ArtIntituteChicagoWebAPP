//
//  ArtHistoryManager.swift
//  ArtIntituteChicago
//
//  Created by Natalia Goyes on 12/04/22.
//

import Foundation
import UIKit
import CoreData

protocol FetchArtHistoryCDProtocol: AnyObject {
    func fetchHistory(with id: Int, onSuccess: ((DetailedArtWork)-> Void)?, onError: (()->Void)?)
}

class FetchArtHistoryCD: FetchArtHistoryCDProtocol {
    func fetchHistory(with id: Int, onSuccess: ((DetailedArtWork)-> Void)?, onError: (()->Void)?){
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            onError?()
            return
        }
        let context = delegate.coreDataManager.getViewContext()
        let fetchRequest: NSFetchRequest<DBArtWork> = DBArtWork.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = \(id)")
        do {
            let entityDBArtwork = try context.fetch(fetchRequest)
            let artworksHistory = entityDBArtwork.map { return convertEntityToArtwork($0)}
            onSuccess?(artworksHistory[0])
        } catch {
            print("error fetching departments")
            onError?()
        }
    }
    func convertEntityToArtwork(_ seenArt: DBArtWork) -> DetailedArtWork {
        let seenArt = DetailedArtWork(
            id: Int(seenArt.id),
            title: seenArt.title ?? "",
            lastSeenDate: seenArt.lastSeen ?? Date(),
            artist: seenArt.artist,
            artistBirthdate: Int(seenArt.artistBirthdate),
            artistDeathdate: Int(seenArt.artistBirthdate),
            image: seenArt.image)
        return seenArt
    }
}
