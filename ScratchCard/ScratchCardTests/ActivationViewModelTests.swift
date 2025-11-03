//
//  ActivationViewModelTests.swift
//  ScratchCardTests
//
//  Created by Marek Hajdučák on 03/11/2025.
//

import XCTest
@testable import ScratchCard

@MainActor
final class ActivationViewModelTests: XCTestCase {
    var sut: ActivationViewModel!
    var mockService: MockActivationService!
    
    override func setUp() {
        super.setUp()
        mockService = MockActivationService()
        sut = ActivationViewModel(activationService: mockService)
    }
    
    func test_whenActivate_ThenSuccess() async throws {
        mockService.mockResult = true
        try await sut.activate(code: "test")
    }
    
    func test_whenActivate_givenFailure_thenThrowsError() async {
        mockService.shouldThrow = true
        
        do {
            try await sut.activate(code: "test")
            XCTFail("Should throw error")
        } catch {
            // Expected
        }
    }
    
    func test_whenActivate_thenIsActivatingIsTrue() async {
        XCTAssertFalse(sut.isActivating)
        
        Task {
            try? await sut.activate(code: "test")
        }
        
        try? await Task.sleep(for: .milliseconds(10))
    }
}
