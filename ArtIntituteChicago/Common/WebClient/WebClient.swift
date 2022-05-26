//
//  WebClient.swift
//  ArtIntituteChicago
//
//  Created by Natalia Goyes on 14/04/22.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

struct Endpoint {
    let url: String
    let httpMethod: HTTPMethod
    let bodyParams: Data?
}

enum WebServiceError: Error {
    case invalidRequest, invalidStatusCodeResponse, errorDecodingData, errorEncodingData
}

protocol WebClient {
    func performRequest(endpoint: Endpoint, onSuccess: @escaping (Data?)->(), onError: @escaping (WebServiceError)->())
}
