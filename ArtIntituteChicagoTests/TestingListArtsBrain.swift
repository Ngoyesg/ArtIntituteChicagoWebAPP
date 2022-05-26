//
//  TestingListArtsBrain.swift
//  ArtIntituteChicagoTests
//
//  Created by Natalia Goyes on 16/05/22.
//

import XCTest
@testable import ArtIntituteChicago


class ListArtsBrainTests: XCTestCase {
    
    var sut: TestingListArtsBrain!

    override func setUp() {
        super.setUp()
        let colaboratorListArtsManager = ColaboratorListArtsManager()
        let colaboratorGetLastSeenManager = ColaboratorGetLastSeenManager()
        let colaboratorSaveLastSeenManager = ColaboratorSaveLastSeenManager()
        
        sut = TestingListArtsBrain(listArtsWebPetitionManager: colaboratorListArtsManager, getLastSeenArtWorkManager: colaboratorGetLastSeenManager, saveLastSeenArtWorkManager: colaboratorSaveLastSeenManager)
        
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_WHEN_fetchArtsIsInvoked_WITH_noParams_THEN_petitionIsDone(){
        sut.fetchDownloadableArtWork()
        XCTAssertTrue(sut.fetchingDispatched)
    }
    
    func test_WHEN_changePageIsCalled_WITH_someStartingPageLike1_THEN_newPageShouldBe2(){
        let currentPageCopy = sut.currentPage
        let expectedPage = currentPageCopy + 1
        sut.changeToNextPage()
        XCTAssertEqual(expectedPage, sut.currentPage)
    }
  
    
    
}
