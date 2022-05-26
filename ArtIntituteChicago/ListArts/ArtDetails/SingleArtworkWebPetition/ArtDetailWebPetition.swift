//
//  ArtDetailWebPetition.swift
//  ArtIntituteChicago
//
//  Created by Natalia Goyes on 9/04/22.
//

import Foundation


protocol ArtDetailWebPetitionProtocol: AnyObject {
    func getArtDetails(artworkId: Int, onSuccess: @escaping (APIArtWork) -> Void, onError: @escaping (Error)-> Void)
}

class ArtDetailWebPetition {
    let webClient : WebClient = RESTClient()
    
    func process(
        response: Data?,
        onSuccess: (APIArtWork) -> Void,
        onError: (Error)-> Void) {
            guard let respuestaParaDecodificar = response else {
                print("no hay data para decodificar")
                onError(WebServiceError.errorDecodingData)
                return
            }
            let decoder = JSONDecoder()
            do {
                let respuestaDecoficada = try decoder.decode(APIArtWork.self, from: respuestaParaDecodificar)
                onSuccess(respuestaDecoficada)
            } catch {
                print("no fue posible decodificar la respuesta")
                onError(WebServiceError.errorDecodingData)
            }
    }
}

extension ArtDetailWebPetition: ArtDetailWebPetitionProtocol {
    func getArtDetails(artworkId: Int, onSuccess: @escaping (APIArtWork) -> Void, onError: @escaping (Error)-> Void ) {
        let endpoint = Endpoint(url: "https://api.artic.edu/api/v1/artworks/\(artworkId)", httpMethod: .GET, bodyParams: nil)
        webClient.performRequest(endpoint: endpoint) { [weak self] data in
            guard let self = self else {
                return
            }
            self.process(response: data, onSuccess: onSuccess, onError: onError)
        } onError: { error in
            onError(error)
        }
    }
}
