//
//  ActivationService.swift
//  O2ScratchCard
//
//  Created by Marek Hajdučák on 03/11/2025.
//

import Foundation

protocol ActivationServiceProtocol {
    func activate(code: String) async throws -> Bool
}

enum ActivationError: Error, LocalizedError {
    case invalidResponse
    case activationFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse: return "Ivalid API response."
        case .activationFailed: return "Activation Faild: iOS version is too low."
        }
    }
}

public final class ActivationService: ActivationServiceProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func activate(code: String) async throws -> Bool {
        guard var components = URLComponents(string: "https://api.o2.sk/version") else {
            throw ActivationError.invalidResponse
        }
        
        components.queryItems = [URLQueryItem(name: "code", value: code)]
        guard let url = components.url else {
            throw ActivationError.invalidResponse
        }
        
        let (data, _) = try await session.data(from: url)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        guard let iosVersionString = json?["ios"] as? String,
              let iosVersion = Double(iosVersionString)
        else {
            throw ActivationError.invalidResponse
        }
        
        if iosVersion > 6.1 {
            return true
        } else {
            throw ActivationError.activationFailed
        }
    }
}
