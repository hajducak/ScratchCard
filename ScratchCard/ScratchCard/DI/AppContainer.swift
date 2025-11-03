//
//  AppContainer.swift
//  O2ScratchCard
//
//  Created by Marek Hajdučák on 03/11/2025.
//

import Foundation

protocol AppContainerProtocol {
    var scratchService: ScratchServiceProtocol { get }
    var activationService: ActivationServiceProtocol { get }
}

final class AppContainer: AppContainerProtocol {
    static let shared = AppContainer()

    let scratchService: ScratchServiceProtocol
    let activationService: ActivationServiceProtocol

    init(
        scratchService: ScratchServiceProtocol = ScratchService(),
        activationService: ActivationServiceProtocol = ActivationService()
    ) {
        self.scratchService = scratchService
        self.activationService = activationService
    }
}
