//
//  ScratchServiceTests.swift
//  ScratchCardTests
//
//  Created by Marek Hajdučák on 03/11/2025.
//

import XCTest
@testable import ScratchCard

final class ScratchServiceTests: XCTestCase {
    var sut: ScratchService!
    
    override func setUp() {
        super.setUp()
        sut = ScratchService()
    }
    
    func test_whenScratch_thenReturnsUUIDString() async throws {
        let code = try await sut.scratch()
        XCTAssertFalse(code.isEmpty)
        XCTAssertNotNil(UUID(uuidString: code), "Should return valid UUID")
    }
    
    func test_whenScratch_thanTakesApproximately2Seconds() async throws {
        let start = Date()
        _ = try await sut.scratch()
        let duration = Date().timeIntervalSince(start)
        XCTAssertGreaterThan(duration, 1.9)
        XCTAssertLessThan(duration, 2.5)
    }
}
