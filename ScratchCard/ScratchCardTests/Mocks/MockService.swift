//
//  MockScratchService.swift
//  ScratchCardTests
//
//  Created by Marek Hajdučák on 03/11/2025.
//

import XCTest
@testable import ScratchCard

final class MockScratchService: ScratchServiceProtocol {
    var shouldThrow = false
    var delay: TimeInterval = 0
    var mockCode = "TEST-CODE-123"
    
    func scratch() async throws -> String {
        if delay > 0 {
            try await Task.sleep(for: .seconds(delay))
        }
        if shouldThrow {
            throw NSError(domain: "Test", code: -1)
        }
        return mockCode
    }
}

final class MockActivationService: ActivationServiceProtocol {
    var shouldThrow = false
    var mockResult = true
    
    func activate(code: String) async throws -> Bool {
        if shouldThrow {
            throw ActivationError.activationFailed
        }
        return mockResult
    }
}

final class MockURLProtocol: URLProtocol {
    static var mockResponse: (data: Data, response: URLResponse)?
    static var error: Error?
    
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    
    override func startLoading() {
        if let error = MockURLProtocol.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        if let (data, response) = MockURLProtocol.mockResponse {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
