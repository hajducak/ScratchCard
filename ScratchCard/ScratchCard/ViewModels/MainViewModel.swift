//
//  MainViewModel.swift
//  ScratchCard
//
//  Created by Marek Hajdučák on 03/11/2025.
//

import Foundation
import SwiftUI

@MainActor
final class MainViewModel: ObservableObject {
    @Published var card: ScratchCard
    private let container: AppContainer
    
    let scratchViewModel: ScratchViewModel
    let activationViewModel: ActivationViewModel
    
    init(container: AppContainer) {
        self.card = ScratchCard()
        self.container = container
        
        self.scratchViewModel = ScratchViewModel(scratchService: container.scratchService)
        self.activationViewModel = ActivationViewModel(activationService: container.activationService)
    }
    
    func updateState(_ newState: ScratchCardState) {
        card.state = newState
    }
    
    var stateTitle: String {
        switch card.state {
        case .unscratched: return "Scratch to reveal your recharge code."
        case .scratching: return "Please wait a moment ..."
        case .scratched: return "Copy your code or activate it below."
        case .activating: return "Contacting O₂ service ..."
        case .activated: return "Your card has been successfully activated!"
        case .error(let message): return "Please try again later. Error: \(message)."
        }
    }
    
    var code: String? {
        switch card.state {
        case .scratched(let code), .activating(let code), .activated(let code):
            return code
        default: return nil
        }
    }
    
    var stateDescription: String {
        switch card.state {
        case .unscratched: return "Unscratched"
        case .scratching: return "Scratching..."
        case .scratched: return "Scratched"
        case .activating: return "Activating..."
        case .activated: return "Activated ✅"
        case .error(let message): return "Error: \(message)"
        }
    }
}
