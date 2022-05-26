//
//  HistoryBrain.swift
//  ArtIntituteChicago
//
//  Created by Natalia Goyes on 8/04/22.
//

import Foundation

protocol HistoryBrainProtocol: AnyObject {
    func setController(controller: HistoryViewControllerProtocol?)
    func getNumberOfRows()-> Int
    func getArtWork(for row: Int) -> DetailedArtWork
    func artWorkWasSelected(at row: Int)
    func processViewDidAppear()
    func getIdForDetails() -> Int
}

class HistoryBrain {
    private weak var controller: HistoryViewControllerProtocol?
    private let historyManager: ArtworkHistoryManagerProtocol = ArtworkHistoryManager()
    private var artworkSeenHistory: [DetailedArtWork] = []
    private var artWorkIDToDetails: Int?
    
    func fetchHistory(){
        historyManager.fetchHistory { [weak self] downloadable in
            guard let self = self else {return}
            self.artworkSeenHistory = downloadable
            self.controller?.reloadTable()
        } onError: {
            print("error fetching history")
        }
    }
}

extension HistoryBrain: HistoryBrainProtocol {
    func setController(controller: HistoryViewControllerProtocol?) {
        self.controller = controller
    }
    func getNumberOfRows()-> Int{
        return artworkSeenHistory.count
    }
    func getArtWork(for row: Int) -> DetailedArtWork {
        return artworkSeenHistory[row]
    }
    func artWorkWasSelected(at row: Int){
        let selectedArtWork = artworkSeenHistory[row]
        artWorkIDToDetails = selectedArtWork.id
        controller?.goToArtDetailsViewController()
    }
    func getIdForDetails() -> Int {
        return artWorkIDToDetails!
    }
    func processViewDidAppear(){
        fetchHistory()
    }
}
