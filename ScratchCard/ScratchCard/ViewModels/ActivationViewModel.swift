//
//  ActivationViewModel.swift
//  ScratchCard
//
//  Created by Marek Hajdučák on 03/11/2025.
//

import Foundation

@MainActor
final class ActivationViewModel: ObservableObject {
    @Published var isActivating = false
    private let activationService: ActivationServiceProtocol

    init(activationService: ActivationServiceProtocol) {
        self.activationService = activationService
    }

    func activate(code: String) async throws {
        isActivating = true
        defer { isActivating = false }

        let success = try await activationService.activate(code: code)
        guard success else {
            throw NSError(domain: "Activation", code: -1, userInfo: [NSLocalizedDescriptionKey: "Activation failed"])
        }
    }
}
