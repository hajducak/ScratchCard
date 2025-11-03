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
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid API response."
        case .activationFailed:
            return "Activation Failed: iOS version is too low (requires > 6.1)."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

public final class ActivationService: ActivationServiceProtocol {
    private let session: URLSession
    private let baseURL = "https://api.o2.sk/version"
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func activate(code: String) async throws -> Bool {
        guard var components = URLComponents(string: baseURL) else {
            throw ActivationError.invalidResponse
        }
        
        components.queryItems = [URLQueryItem(name: "code", value: code)]
        
        guard let url = components.url else {
            throw ActivationError.invalidResponse
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw ActivationError.invalidResponse
            }
            
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let iosVersionString = json["ios"] as? String,
                  let iosVersion = Double(iosVersionString) else {
                throw ActivationError.invalidResponse
            }
            
            guard iosVersion > 6.1 else {
                throw ActivationError.activationFailed
            }
            
            return true
            
        } catch let error as ActivationError {
            throw error
        } catch {
            throw ActivationError.networkError(error)
        }
    }
}
