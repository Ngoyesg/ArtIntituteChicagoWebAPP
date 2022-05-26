//
//  HistoryDataManagerTests.swift
//  ArtIntituteChicagoTests
//
//  Created by Natalia Goyes on 15/05/22.
//

import XCTest
import CoreData
@testable import ArtIntituteChicago

class HistoryDataManagerTests: XCTestCase {
    
    var sut: ArtworkHistoryManagerFake!
    var coreDataStack: CoreDataTest!
    
    
    override func setUp() {
        super.setUp()
        sut = ArtworkHistoryManagerFake()
        coreDataStack = CoreDataTest()
        
    }

    override func tearDown()  {
        sut = nil
        coreDataStack = nil
        super.tearDown()
    }
    
    func test_WHEN_fetchedHistoryIsCalled_WITH_NoParameters_THEN_itShouldInvokeMethod(){
        sut.fetchHistory { X in
        } onError: {
        }
        XCTAssertTrue(sut.processCalled)
    }

}
