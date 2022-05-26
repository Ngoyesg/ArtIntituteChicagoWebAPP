//
//  ListArtsWebRequestTests.swift
//  ArtIntituteChicagoTests
//
//  Created by Natalia Goyes on 13/05/22.
//

import XCTest
@testable import ArtIntituteChicago

class ListArtsWebRequestTests: XCTestCase {

    var sut : TestingListArtWebRequest!
    var fakeWebClient: FakeWebClient!

    override func setUp() {
        super.setUp()
        fakeWebClient = FakeWebClient()
        sut = TestingListArtWebRequest(webClient: fakeWebClient)
        
    }
    override func tearDown() {
        fakeWebClient = nil
        sut = nil
        super.tearDown()
    }

    func test_WHEN_getEndpointIsExecuted_GIVEN_somePageLike10_THEN_itShouldReturnSomeEndpoint(){
        let pageToTest = 10
        let actualResult = sut.getEndpointForCurrentPage(currentPage: pageToTest)
        let expectedResult = Endpoint(url: "https://api.artic.edu/api/v1/artworks?page=\(pageToTest)", httpMethod: .GET, bodyParams: nil)
        XCTAssertEqual(actualResult.url, expectedResult.url)
        XCTAssertEqual(actualResult.httpMethod, expectedResult.httpMethod)
        XCTAssertEqual(actualResult.bodyParams, expectedResult.bodyParams)
        XCTAssertFalse(fakeWebClient.performRequestCalled)
    }
    
    func test_WHEN_getPaginationIsExecuted_GIVEN_someCurrentPageLike1_THEN_itShouldInvokePerformRequestOnWebClient(){
        sut.getPagination(currentPage: 1) { X in
            
        } onError: { Y in
            
        }
        XCTAssertTrue(fakeWebClient.performRequestCalled)
    }
    
    func test_WHEN_getPaginationIsExecuted_GIVEN_someCurrentPageLike1AndWebClientSuccessWithSomeEncodedResponse_THEN_itShouldInvokeProcess(){
        fakeWebClient.success = true
        let pagination = APIPagination(artWorks: [], config: ArtWorkConfig(baseImageURL: nil))
        let encodedData = try! JSONEncoder().encode(pagination)
        fakeWebClient.someData = encodedData
        sut.getPagination(currentPage: 1) { X in
            
        } onError: { Y in
            XCTFail()
        }
        XCTAssertTrue(sut.processCalled)
    }
    
    func test_WHEN_getPaginationIsExecuted_GIVEN_someCurrentPageLike1AndWebClientError_THEN_itShouldInvokeErrorClosure(){
        fakeWebClient.success = false
        
        let expectation = XCTestExpectation(description: "Error is expected")
        
        sut.getPagination(currentPage: 1) { X in
            XCTFail()
        } onError: { Y in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
        
    }
    
    func test_WHEN_processIsExecuted_GIVEN_someNilData_THEN_itShouldCallOnError(){
        sut.process(response: nil) { X in
            XCTFail()
        } onError: { error in
            XCTAssertEqual(error as! WebServiceError, WebServiceError.errorDecodingData)
        }

    }
    
    func test_WHEN_processIsExecuted_GIVEN_someData_THEN_itShouldCallOnError(){
        sut.process(response: Data()) { X in
            XCTFail()
        } onError: { error in
            XCTAssertEqual(error as! WebServiceError, WebServiceError.errorEncodingData)
        }

    }
    
    func test_WHEN_processIsExecuted_GIVEN_someValidData_THEN_itShouldCallOnSuccess(){
        let pagination = APIPagination(artWorks: [], config: ArtWorkConfig(baseImageURL: nil))
        let encodedData = try! JSONEncoder().encode(pagination)
        let expectation = XCTestExpectation(description: "Success is expected")
        let unexpectedBranch = XCTestExpectation(description: "Error is not expected")
        unexpectedBranch.isInverted = true
        sut.process(response: encodedData) { X in
            expectation.fulfill()
        } onError: { error in
            unexpectedBranch.fulfill()
        }

        wait(for: [expectation, unexpectedBranch], timeout: 0.1)

        
    }

}
