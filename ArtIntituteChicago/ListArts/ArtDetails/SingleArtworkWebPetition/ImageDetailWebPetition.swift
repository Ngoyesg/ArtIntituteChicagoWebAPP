//
//  ArtImageWebPetition.swift
//  ArtIntituteChicago
//
//  Created by Natalia Goyes on 9/04/22.
//

import Foundation
import UIKit

protocol ImageDetailWebPetitionProtocol: AnyObject {
    func getImageDetails(imageID: String, onSuccess: @escaping (Data) -> Void, onError: @escaping (Error)-> Void)
}

class ImageDetailWebPetition {
    let client: WebClient = RESTClient()
    
    func process(
        response: Data?,
        onSuccess: (Data) -> Void,
        onError: (Error)-> Void) {
            guard let respuestaParaDecodificar = response else {
                print("no hay data para decodificar")
                onError(WebServiceError.errorDecodingData)
                return
            }
            onSuccess(respuestaParaDecodificar)
    }
}

extension ImageDetailWebPetition: ImageDetailWebPetitionProtocol {
    func getImageDetails(imageID: String, onSuccess: @escaping (Data) -> Void, onError: @escaping (Error)-> Void) {
        let endpoint = Endpoint(url: "https://www.artic.edu/iiif/2/\(imageID)/full/843,/0/default.jpg", httpMethod: .GET, bodyParams: nil)
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
