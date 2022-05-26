//
//  FakeWebClient.swift
//  ArtIntituteChicagoTests
//
//  Created by Natalia Goyes on 13/05/22.
//
import Foundation
@testable import ArtIntituteChicago

class FakeWebClient: WebClient {
    var performRequestCalled = false
    var success = false
    var someData: Data? = nil
    
    func performRequest(endpoint: Endpoint, onSuccess: @escaping (Data?) -> (), onError: @escaping (WebServiceError) -> ()) {
        performRequestCalled = true
        if success {
            onSuccess(someData)
        } else{
            onError(.errorDecodingData)
        }
    }
}
