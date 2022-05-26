//
//  HistoryDataManager.swift
//  ArtIntituteChicago
//
//  Created by Natalia Goyes on 8/04/22.
//

import UIKit
import CoreData

protocol ArtworkHistoryManagerProtocol: AnyObject {
    func fetchHistory(onSuccess: @escaping ([DetailedArtWork]) -> Void, onError: @escaping () -> Void)
}

class ArtworkHistoryManager:ArtworkHistoryManagerProtocol {
    func fetchHistory(onSuccess: @escaping ([DetailedArtWork]) -> Void, onError: @escaping () -> Void){
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            onError()
            return
        }
        let context = delegate.coreDataManager.getViewContext()
        let fetchRequest: NSFetchRequest<DBArtWork> = DBArtWork.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastSeen", ascending: false)]
        do {
            let entityDBArtwork = try context.fetch(fetchRequest)
            let artworksHistory = entityDBArtwork.map { return convertEntityToArtwork($0)}
            onSuccess(artworksHistory)
        } catch {
            print("error fetching departments")
            onError()
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
