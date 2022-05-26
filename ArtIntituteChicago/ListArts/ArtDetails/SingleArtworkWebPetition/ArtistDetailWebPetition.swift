//
//  ArtistDetailWebPetition.swift
//  ArtIntituteChicago
//
//  Created by Natalia Goyes on 9/04/22.
//

import Foundation

protocol ArtistDetailWebPetitionProtocol: AnyObject {
    func getArtistDetails(artworkId: Int, onSuccess: @escaping (APIArtist) -> Void, onError: @escaping (Error)-> Void)
}

class ArtistDetailWebPetition {
    let client: WebClient = RESTClient()
    
    func process(
        response: Data?,
        onSuccess: (APIArtist) -> Void,
        onError: (Error)-> Void) {
            guard let respuestaParaDecodificar = response else {
                print("no hay data para decodificar")
                onError(WebServiceError.errorDecodingData)
                return
            }
            let decoder = JSONDecoder()
            
            do {
                let respuestaDecoficada = try decoder.decode(APIArtist.self, from: respuestaParaDecodificar)
                onSuccess(respuestaDecoficada)
            } catch {
                print("no fue posible decodificar la respuesta")
                onError(WebServiceError.errorDecodingData)
            }
    }
}

extension ArtistDetailWebPetition: ArtistDetailWebPetitionProtocol {
    func getArtistDetails(artworkId: Int, onSuccess: @escaping (APIArtist) -> Void, onError: @escaping (Error)-> Void) {
        let endpoint = Endpoint(url: "https://api.artic.edu/api/v1/artists/\(artworkId)", httpMethod: .GET, bodyParams: nil)
        client.performRequest(endpoint: endpoint) { [weak self] data in
            guard let self = self else {
                return
            }
            self.process(response: data, onSuccess: onSuccess, onError: onError)
        } onError: { error in
            onError(error)
        }
    }
}
