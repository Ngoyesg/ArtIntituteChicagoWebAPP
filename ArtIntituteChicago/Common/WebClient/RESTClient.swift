//
//  RESTClient.swift
//  ArtIntituteChicago
//
//  Created by Natalia Goyes on 14/04/22.
//

import Foundation

class RESTClient: WebClient {
    func performRequest(endpoint: Endpoint, onSuccess: @escaping (Data?) -> (), onError: @escaping (WebServiceError) -> ()) {
        let urlSessionConfig = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: urlSessionConfig)
        let url = URL(string: endpoint.url)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.httpMethod.rawValue
        let task = urlSession.dataTask(with: urlRequest) { [weak self] (datos, respuestaURL, errores) in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.process(taskResponse: (data: datos, response: respuestaURL, error: errores), onSuccess: onSuccess, onError: onError)
            }
        }
        task.resume()
    }
    
    func process(
        taskResponse: (data: Data?, response: URLResponse?, error: Error?),
        onSuccess: (Data?) -> Void,
        onError: (WebServiceError)-> Void) {
            if let _ = taskResponse.error {
                onError(WebServiceError.invalidRequest)
                return
            }
            if let respuestaXYZ = taskResponse.response as? HTTPURLResponse, !(200..<300).contains(respuestaXYZ.statusCode) {
                print("el estado de codigo de la respuesta es invalido")
                onError(WebServiceError.invalidStatusCodeResponse)
                return
            }
            
            onSuccess(taskResponse.data)
    }
}
