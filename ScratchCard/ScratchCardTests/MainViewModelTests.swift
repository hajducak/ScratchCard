//
//  MainViewModelTests.swift
//  ScratchCardTests
//
//  Created by Marek Hajdučák on 03/11/2025.
//

import XCTest
@testable import ScratchCard

@MainActor
final class MainViewModelTests: XCTestCase {
    var sut: MainViewModel!
    var mockContainer: AppContainer!
    
    override func setUp() {
        super.setUp()
        mockContainer = AppContainer(
            scratchService: MockScratchService(),
            activationService: MockActivationService()
        )
        sut = MainViewModel(container: mockContainer)
    }
    
    func test_whenInitial_thenStateIsUnscratched() {
        XCTAssertEqual(sut.card.state, .unscratched)
    }
    
    func test_whenUpdateState_thenCardStateChanged() {
        sut.updateState(.scratched(code: "ABC"))
        XCTAssertEqual(sut.card.state, .scratched(code: "ABC"))
    }
    
    func test_whenUpdateState_thenStringsAreSet() {
        sut.updateState(.unscratched)
        XCTAssertEqual(sut.stateDescription, "Unscratched")
        
        sut.updateState(.scratched(code: "123"))
        XCTAssertEqual(sut.stateDescription, "Scratched")
        
        sut.updateState(.activated(code: "123"))
        XCTAssertEqual(sut.stateDescription, "Activated ✅")
    }
    
    func test_whenUpdateState_givenScratched_thenReturnsCodeIsSet() {
        sut.updateState(.scratched(code: "TEST-CODE"))
        XCTAssertEqual(sut.code, "TEST-CODE")
    }
    
    func test_whenUpdateState_givenUnscratched_thenCodeIsNil() {
        sut.updateState(.unscratched)
        XCTAssertNil(sut.code)
    }
}
