//
//  ListArtsBrain.swift
//  ArtIntituteChicago
//
//  Created by Natalia Goyes on 8/04/22.
//

import Foundation
import UIKit

protocol ListArtsBrainProtocol: AnyObject {
    func setController(controller: ListArtsViewControllerProtocol?)
    func getNumberOfRows()-> Int
    func getArtWork(for row: Int) -> ArtWork
    func artWorkWasSelected(at row: Int)
    func getIdForDetails() -> Int
    func downloadMoreData()
    func processDidLoad()
    func processViewDidAppear()
}

class ListArtsBrain {
    struct Constants {
        static let maxSecondsLastSeenArt = 10.0
    }
    
    private weak var controller: ListArtsViewControllerProtocol?
    
    var currentPage = 0
    private var downloadedPage: APIPagination?
    var allArtWorks: [ArtWork] = []
    private var selectedArtworkID: Int?
    private var isPaginating: Bool = false
    private let listArtsWebPetitionManager: ListArtWebRequestProtocol
    private let getLastSeenArtWorkManager: GetLastSeenManagerProtocol
    private let saveLastSeenArtWorkManager: SaveLastSeenManagerProtocol
    
    init(listArtsWebPetitionManager: ListArtWebRequestProtocol, getLastSeenArtWorkManager: GetLastSeenManagerProtocol, saveLastSeenArtWorkManager: SaveLastSeenManagerProtocol){
        self.listArtsWebPetitionManager = listArtsWebPetitionManager
        self.getLastSeenArtWorkManager = getLastSeenArtWorkManager
        self.saveLastSeenArtWorkManager = saveLastSeenArtWorkManager
    }
    
    func fetchDownloadableArtWork(){
        self.isPaginating = true
        self.listArtsWebPetitionManager.getPagination(currentPage: self.currentPage) { [weak self] newPageOfArtWorks in
            guard let self = self else {
                return
            }
            self.isPaginating = false
            self.processSuccessDownload(newPageOfArtworks: newPageOfArtWorks)
        } onError: { [weak self] errores in
            guard let self = self else {
                return
            }
            self.isPaginating = false
            self.processFailedDownload()
        }
    }
    
    func processSuccessDownload(newPageOfArtworks: APIPagination) {
        updateArtWorks(newPageOfArtworks: newPageOfArtworks)
        self.controller?.stopSpinner()
        self.controller?.reloadTable()
    }
    
    func updateArtWorks(newPageOfArtworks: APIPagination){
        self.downloadedPage = newPageOfArtworks
        if let artWorks = downloadedPage?.artWorks {
            self.allArtWorks += artWorks
        }
    }
    
    func processFailedDownload() {
        self.controller?.stopSpinner()
        self.controller?.alertDownloadedFailed()
    }
    
    func displayLastSeen() {
        guard let lastSeen = getLastSeenArtWorkManager.getArtWork() else {
            return
        }
        let timeElapsedLastSeen = ArtworkTimeManager.secondsElapsed(from: lastSeen.lastSeenDate)
        if timeElapsedLastSeen < Constants.maxSecondsLastSeenArt {
            fillLastSeenInfoBox(with: lastSeen)
        }
    }
    
    func wasSeenWithinLimit(lastSeen date: Date, limit maxTime: Int) -> Bool{
        return date.timeIntervalSince(Date()) <= Double(maxTime)
    }
    
    func fillLastSeenInfoBox(with lastWork: LastSeenArtWork){
        guard let controller = controller else {
            return
        }
        
        controller.setLastSeenTitle("Title: \(lastWork.title)")
        controller.setLastSeenArtist("Artist: \(lastWork.artist ?? "Information not found")")

        let lastSeenDateToShow = ArtworkDateFormatter.convertDateToString(from: lastWork.lastSeenDate)
        controller.setLastSeenDate("Last seen on: \(lastSeenDateToShow)")
        
        controller.showLastSeenInfoBox()
    }
    
    func updateLastSeenArtWork(with lastSeen: ArtWork){
        let lastSeenArtwork = LastSeenArtWork(title: lastSeen.title, artist: lastSeen.artist, lastSeenDate: Date())
        saveLastSeenArtWorkManager.saveArtWork(lastArtSeen: lastSeenArtwork)
    }
    
    func changeToNextPage() {
        self.currentPage += 1
    }
}

extension ListArtsBrain: ListArtsBrainProtocol {
    func processDidLoad(){
        self.fetchDownloadableArtWork()
    }
    func processViewDidAppear(){
        displayLastSeen()
    }
    func setController(controller: ListArtsViewControllerProtocol?) {
        self.controller = controller
    }
    func getNumberOfRows()-> Int{
        return allArtWorks.count
    }
    func getArtWork(for row: Int) -> ArtWork {
        return allArtWorks[row]
    }
    func artWorkWasSelected(at row: Int){
        let selectedArtWork = allArtWorks[row]
        selectedArtworkID = selectedArtWork.id
        updateLastSeenArtWork(with:selectedArtWork)
        controller?.goToArtDetailsViewController()
    }
    func getIdForDetails() -> Int {
        return selectedArtworkID!
    }
    func downloadMoreData(){
        guard !isPaginating else {
            return
        }
        controller?.startSpinner()
        changeToNextPage()
        fetchDownloadableArtWork()
    }
}
