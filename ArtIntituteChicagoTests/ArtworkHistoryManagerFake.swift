//
//  ArtworkHistoryManagerFake.swift
//  ArtIntituteChicagoTests
//
//  Created by Natalia Goyes on 15/05/22.
//

import XCTest
@testable import ArtIntituteChicago

class ArtworkHistoryManagerFake: ArtworkHistoryManager {
    
    var processCalled = false
    
    override func fetchHistory(onSuccess: @escaping ([DetailedArtWork]) -> Void, onError: @escaping () -> Void) {
        processCalled = true
        super.fetchHistory(onSuccess: onSuccess, onError: onError)
    }
    
}
