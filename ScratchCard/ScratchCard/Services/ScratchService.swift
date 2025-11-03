//
//  ScratchService.swift
//  O2ScratchCard
//
//  Created by Marek Hajdučák on 03/11/2025.
//

import Foundation

protocol ScratchServiceProtocol {
    func scratch() async throws -> String
}

public final class ScratchService: ScratchServiceProtocol {
    func scratch() async throws -> String {
        try await Task.sleep(for: .seconds(2))
        return UUID().uuidString
    }
}
