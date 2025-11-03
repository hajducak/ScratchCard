//
//  AppContainer.swift
//  O2ScratchCard
//
//  Created by Marek Hajdučák on 03/11/2025.
//

import Foundation

final class AppContainer {
    static let shared = AppContainer()
    
    let scratchService: ScratchServiceProtocol
    let activationService: ActivationServiceProtocol
    
    init() {
        self.scratchService = ScratchService()
        self.activationService = ActivationService()
    }
}
