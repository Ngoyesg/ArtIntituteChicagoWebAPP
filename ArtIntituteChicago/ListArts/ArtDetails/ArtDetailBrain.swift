//
//  ArtDetailBrain.swift
//  ArtIntituteChicago
//
//  Created by Natalia Goyes on 8/04/22.
//

import Foundation
import UIKit

protocol ArtDetailBrainProtocol: AnyObject {
    func setController(controller: ArtDetailViewControllerProtocol?)
    func setIDToFetch(id: Int)
    func processViewDidLoad()
    func setComingFromHistory()
}

class ArtDetailBrain {
    private weak var controller: ArtDetailViewControllerProtocol?
    
    private var isShowingHistory = false
    private var showErrorMessage = false
    private var idToFetch: Int?
    private var detailedSeenArt: DetailedArtWork?
    
    private let fetchArtDetailsUseCase: FetchArtDetailsUseCaseProtocol = FetchArtDetailsUseCase()
    private let fetchHistoryManager: FetchArtHistoryCDProtocol = FetchArtHistoryCD()
    
    func fetchInfoFromWeb() {
        guard let idToFetch = idToFetch else {
            return
        }
        fetchArtDetailsUseCase.execute(idToFetch: idToFetch) { detailedArt in
            self.detailedSeenArt = detailedArt
            self.fillDisplay()
            self.controller?.stopSpinner()
            self.controller?.displayInfoBox()
        } onError: { error in
            self.controller?.alertDownloadedFailed(error: error)
            self.controller?.stopSpinner()
        }
    }

    func fetchInfoFromCoreData(){
        guard let idToFetch = idToFetch else {
            return
        }
        self.fetchHistoryManager.fetchHistory(with: idToFetch) { [weak self] artworkSeen in
            guard let self = self else {
                return
            }
            self.detailedSeenArt = artworkSeen
            self.fillDisplay()
        } onError: {
            print("unable to fetch from core data")
        }
    }
    
    func fillDisplay(){
        guard let detailedSeenArt = self.detailedSeenArt else {
            return
        }
        self.editArtworkLabels(
            title: detailedSeenArt.title,
            id: detailedSeenArt.id,
            artist: detailedSeenArt.artist,
            birthdate: detailedSeenArt.artistBirthdate,
            deathdate: detailedSeenArt.artistDeathdate,
            image: detailedSeenArt.image != nil ? UIImage(data: detailedSeenArt.image!) : nil)
    }
    func editArtworkLabels(title: String, id: Int, artist: String?, birthdate: Int?, deathdate: Int?, image: UIImage?){
        guard let controller = self.controller else{return}
        controller.displayInfoBox()
        controller.setTitle(with: title)
        controller.setArtID(with: id)
        controller.setArtist(with: artist)
        controller.setArtistBirthdate(with: birthdate)
        controller.setArtistDateOfDeath(with: deathdate)
        controller.setImage(with: image)
    }
}

extension ArtDetailBrain: ArtDetailBrainProtocol {
    func setController(controller: ArtDetailViewControllerProtocol?) {
        self.controller = controller
    }
    func setIDToFetch(id: Int) {
        self.idToFetch = id
    }
    func setComingFromHistory(){
        self.isShowingHistory = true
    }
    func processViewDidLoad() {
        controller?.startSpinner()
        if isShowingHistory {
            self.fetchInfoFromCoreData()
            self.controller?.stopSpinner()
        } else {
            self.fetchInfoFromWeb()
        }
    }
}
