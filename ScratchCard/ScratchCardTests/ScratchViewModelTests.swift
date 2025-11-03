//
//  ScratchViewModelTests.swift
//  ScratchCardTests
//
//  Created by Marek Hajdučák on 03/11/2025.
//

import XCTest
@testable import ScratchCard

@MainActor
final class ScratchViewModelTests: XCTestCase {
    var sut: ScratchViewModel!
    var mockService: MockScratchService!
    
    override func setUp() {
        super.setUp()
        mockService = MockScratchService()
        sut = ScratchViewModel(scratchService: mockService)
    }
    
    func test_whenStartScratching_givenSuccess_thenCallsOnComplete() async {
        let expectation = expectation(description: "Scratching completes")
        mockService.mockCode = "TEST-123"
        
        sut.startScratching { result in
            if case .success(let code) = result {
                XCTAssertEqual(code, "TEST-123")
                expectation.fulfill()
            }
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func test_whenStartScratching_thenIsScratchingIsTrue() {
        XCTAssertFalse(sut.isScratching)
        
        sut.startScratching { _ in }
        XCTAssertTrue(sut.isScratching)
    }
    
    func test_whenCancelScratching_thenTaskIsCanceled() async {
        mockService.delay = 5.0
        let expectation = expectation(description: "Called")
        
        sut.startScratching { _ in
            expectation.fulfill()
        }
        
        try? await Task.sleep(for: .milliseconds(100))
        sut.cancelScratching()
        
        XCTAssertFalse(sut.isScratching)
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
