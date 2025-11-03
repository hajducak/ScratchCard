//
//  MainViewModel.swift
//  ScratchCard
//
//  Created by Marek Hajdučák on 03/11/2025.
//

import Foundation
@MainActor
final class MainViewModel: ObservableObject {
    @Published var card: ScratchCard
    private let container: AppContainer
    
    init(container: AppContainer) {
        self.card = ScratchCard()
        self.container = container
    }
    
    func updateState(_ newState: ScratchCardState) {
        card.state = newState
    }
    
    var stateDescription: String {
        switch card.state {
        case .unscratched: return "Unscratched"
        case .scratching: return "Scratching..."
        case .scratched: return "Scratched"
        case .activating: return "Activating..."
        case .activated: return "Activated"
        case .error(let message): return "Error: \(message)"
        }
    }
}
