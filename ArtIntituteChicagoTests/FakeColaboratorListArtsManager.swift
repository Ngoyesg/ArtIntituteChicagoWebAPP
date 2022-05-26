//
//  FakeColaboratorListArtsManager.swift
//  ArtIntituteChicagoTests
//
//  Created by Natalia Goyes on 16/05/22.
//

import Foundation
@testable import ArtIntituteChicago

class ColaboratorListArtsManager: ListArtWebRequestProtocol {
    
    var functionInvoked = false
    
    func getPagination(currentPage: Int, onSuccess: ((APIPagination) -> Void)?, onError: ((Error) -> Void)?) {
        functionInvoked = true
    }
}
