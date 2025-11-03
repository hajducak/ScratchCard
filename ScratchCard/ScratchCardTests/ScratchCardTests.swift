//
//  ScratchCardTests.swift
//  ScratchCardTests
//
//  Created by Marek Hajdučák on 03/11/2025.
//

import XCTest
@testable import ScratchCard

final class ScratchCardTests: XCTestCase {
    func testInitialState_IsUnscratched() {
        let card = ScratchCard()
        XCTAssertEqual(card.state, .unscratched)
    }
    
    func testEquatable_WorksCorrectly() {
        let card1 = ScratchCard(state: .unscratched)
        let card2 = ScratchCard(state: .unscratched)
        XCTAssertEqual(card1, card2)
        
        let card3 = ScratchCard(state: .scratched(code: "123"))
        XCTAssertNotEqual(card1, card3)
    }
}

final class ScratchCardStateTests: XCTestCase {
    func testStateEquality() {
        XCTAssertEqual(ScratchCardState.unscratched, .unscratched)
        XCTAssertEqual(ScratchCardState.scratched(code: "A"), .scratched(code: "A"))
        XCTAssertNotEqual(ScratchCardState.scratched(code: "A"), .scratched(code: "B"))
    }
}
