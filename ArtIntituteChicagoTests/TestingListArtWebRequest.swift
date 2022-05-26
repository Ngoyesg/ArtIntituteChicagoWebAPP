//
//  TestingListArtWebRequest.swift
//  ArtIntituteChicagoTests
//
//  Created by Natalia Goyes on 13/05/22.
//

import Foundation
@testable import ArtIntituteChicago

class TestingListArtWebRequest: ListArtWebRequest {
    
    var processCalled = false
    
    override func process(response: Data?, onSuccess: ((APIPagination) -> Void)?, onError: ((Error) -> Void)?) {
        processCalled = true
        super.process(response: response, onSuccess: onSuccess, onError: onError)
        
    }
}
