//
//  ListArtsWebPetition.swift
//  ArtIntituteChicago
//
//  Created by Natalia Goyes on 8/04/22.
//

import Foundation

protocol ListArtWebRequestProtocol: AnyObject {
    func getPagination(currentPage: Int, onSuccess: ((APIPagination) -> Void)?, onError: ((Error)-> Void)?)
}

class ListArtWebRequest {
    let webClient: WebClient
    
    init(webClient: WebClient){
        self.webClient = webClient
    }
    
    func process(
        response: Data?,
        onSuccess: ((APIPagination) -> Void)?,
        onError: ((Error)-> Void)?) {
            guard let respuestaParaDecodificar = response else {
                print("no hay data para decodificar")
                onError?(WebServiceError.errorDecodingData)
                return
            }
            let decoder = JSONDecoder()
            do {
                let respuestaDecoficada = try decoder.decode(APIPagination.self, from: respuestaParaDecodificar)
                onSuccess?(respuestaDecoficada)
            } catch {
                print("no fue posible decodificar la respuesta")
                onError?(WebServiceError.errorEncodingData)
            }
        }
    
    func getEndpointForCurrentPage(currentPage: Int) -> Endpoint {
        return Endpoint(url: "https://api.artic.edu/api/v1/artworks?page=\(currentPage)", httpMethod: .GET, bodyParams: nil)
    }
}

extension ListArtWebRequest: ListArtWebRequestProtocol {
    func getPagination(currentPage: Int, onSuccess: ((APIPagination) -> Void)?, onError: ((Error)-> Void)?) {
        let endpoint = getEndpointForCurrentPage(currentPage: currentPage)
        webClient.performRequest(
            endpoint: endpoint) { [weak self] data in
                guard let self = self else {
                    return
                }
                
                self.process(response: data, onSuccess: onSuccess, onError: onError)
            } onError: { error in
                onError?(error)
            }
    }
}
