//
//  FetchArtDetailsUseCase.swift
//  ArtIntituteChicago
//
//  Created by Natalia Goyes on 14/04/22.
//

import UIKit

enum FetchArtDetailsUseCaseError: Error {
    case unavailableArtDetail
    case imageUnavailable
    case artistUnavailable
}

protocol FetchArtDetailsUseCaseProtocol {
    func execute(idToFetch: Int, onSuccess: @escaping (DetailedArtWork)->(), onError: @escaping (Error) -> ())
}

class FetchArtDetailsUseCase {
    private let detailsManager: ArtDetailWebPetitionProtocol = ArtDetailWebPetition()
    private let artistManager: ArtistDetailWebPetitionProtocol = ArtistDetailWebPetition()
    private let imageManager: ImageDetailWebPetitionProtocol = ImageDetailWebPetition()
    private let storeHistoryManager: StoreArtDetailsCDProtocol = StoreArtDetailsCD()
    
    private let dispatchQueue = DispatchQueue(label: "Serial tasks")
    private let semaphore = DispatchSemaphore(value: 1)
    
    private var artWorkFetched: ArtWork?
    private var artistFetched: Artist?
    private var image: Data?
    
    private var idToFetch: Int = -1
    
    private var error: FetchArtDetailsUseCaseError?
    
    func fetchArtDetails(){
        self.detailsManager.getArtDetails(artworkId: idToFetch) { [weak self] downloadable in
            guard let self = self else {return}
            self.artWorkFetched = downloadable.artWorks
            self.semaphore.signal()
        } onError: { [weak self] errors in
            guard let self = self else {return}
            self.error = .unavailableArtDetail
            self.semaphore.signal()
        }
    }
    
    func fetchImage(){
        guard let imageId = artWorkFetched?.imageId, self.error == nil else {
            self.semaphore.signal()
            return
        }
        self.imageManager.getImageDetails(imageID: imageId) {  [weak self] imageurl  in
            guard let self = self else {return}
            self.image = imageurl
            self.semaphore.signal()
        } onError: {  [weak self] errors  in
            guard let self = self else {return}
            self.error = .imageUnavailable
            self.semaphore.signal()
        }
    }
    
    func fetchArtistDetails(){
        guard let artistId =  artWorkFetched?.artistId, self.error != nil else {
            self.semaphore.signal()
            return
        }
        self.artistManager.getArtistDetails(artworkId: artistId) { [weak self] artist in
            guard let self = self else {return}
            self.artistFetched = artist.artistInfo
            self.semaphore.signal()
        } onError: { [weak self] errors  in
            guard let self = self else {return}
            self.error = .artistUnavailable
            self.semaphore.signal()
        }
    }
    
    func saveArtWorkSeen(_ artworkToSave: DetailedArtWork){
        
    }
    
}

extension FetchArtDetailsUseCase: FetchArtDetailsUseCaseProtocol {
    func execute(idToFetch: Int, onSuccess: @escaping (DetailedArtWork) -> (), onError: @escaping (Error) -> ()) {
        self.idToFetch = idToFetch
        self.error = nil
        dispatchQueue.async {
            self.semaphore.wait()
            self.fetchArtDetails()
        }
        dispatchQueue.async {
            self.semaphore.wait()
            self.fetchImage()
        }
        dispatchQueue.async {
            self.semaphore.wait()
            self.fetchArtistDetails()
        }
        dispatchQueue.async {
            self.semaphore.wait()
            self.semaphore.signal()
            
            DispatchQueue.main.async {
                if let artwork = self.artWorkFetched, self.error != .unavailableArtDetail {
                    let detailedArtWork = DetailedArtWork(id: artwork.id, title: artwork.title, lastSeenDate: Date(), artist: self.artistFetched?.title, artistBirthdate: self.artistFetched?.birthDate, artistDeathdate: self.artistFetched?.deathDate, image: self.image)
                    self.storeHistoryManager.storeArt(artworkToCreate: detailedArtWork) {
                        onSuccess(detailedArtWork)
                    } onError: {
                        onError(FetchArtDetailsUseCaseError.unavailableArtDetail)
                    }
                    return
                } else {
                    onError(FetchArtDetailsUseCaseError.unavailableArtDetail)
                    return
                }
            }
        }
    }
}
