//
//  ActivationServiceTests.swift
//  ScratchCardTests
//
//  Created by Marek Hajdučák on 03/11/2025.
//

import XCTest
@testable import ScratchCard

final class ActivationServiceTests: XCTestCase {
    var sut: ActivationService!
    var mockSession: URLSession!
    
    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        mockSession = URLSession(configuration: config)
        sut = ActivationService(session: mockSession)
    }
    
    override func tearDown() {
        MockURLProtocol.mockResponse = nil
        MockURLProtocol.error = nil
        super.tearDown()
    }
    
    func test_whenActivate_givenVersionGreaterThan61_thenReturnsTrue() async throws {
        let json = ["ios": "6.24"]
        let data = try JSONSerialization.data(withJSONObject: json)
        let response = HTTPURLResponse(
            url: URL(string: "https://api.o2.sk/version")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        MockURLProtocol.mockResponse = (data, response)
        
        let result = try await sut.activate(code: "test-code")
        XCTAssertTrue(result)
    }
    
    func test_whenActivate_givenVersionLessThan61_thanThrowsError() async {
        let json = ["ios": "6.0"]
        let data = try! JSONSerialization.data(withJSONObject: json)
        let response = HTTPURLResponse(
            url: URL(string: "https://api.o2.sk/version")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        MockURLProtocol.mockResponse = (data, response)
        
        do {
            _ = try await sut.activate(code: "test-code")
            XCTFail("Should throw ActivationError.activationFailed")
        } catch let error as ActivationError {
            XCTAssertEqual(error, .activationFailed)
        } catch {
            XCTFail("Wrong error type")
        }
    }
    
    func test_whenActivate_givenInvalidJSON_thenThrowsError() async {
        let data = "invalid".data(using: .utf8)!
        let response = HTTPURLResponse(
            url: URL(string: "https://api.o2.sk/version")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        MockURLProtocol.mockResponse = (data, response)
        
        do {
            _ = try await sut.activate(code: "test-code")
            XCTFail("Should throw error")
        } catch {
            XCTAssertTrue(error is ActivationError || error is NSError)
        }
    }
}
