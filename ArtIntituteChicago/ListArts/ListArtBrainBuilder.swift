//
//  ListArtBrainBuilder.swift
//  ArtIntituteChicago
//
//  Created by Natalia Goyes on 13/05/22.
//

import Foundation

class ListArtBrainBuilder {
    static func build()-> ListArtsBrainProtocol {
        let webClient = RESTClient()
        let listArtWebService = ListArtWebRequest(webClient: webClient)
        let getLastSeenManager = GetLastSeenManager()
        let saveLastSeenManager = SaveLastSeenManager()
        let brain = ListArtsBrain(listArtsWebPetitionManager: listArtWebService, getLastSeenArtWorkManager: getLastSeenManager, saveLastSeenArtWorkManager: saveLastSeenManager)
        return brain
    }
}
