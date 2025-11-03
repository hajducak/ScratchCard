//
//  ActivationViewModel.swift
//  ScratchCard
//
//  Created by Marek Hajdučák on 03/11/2025.
//

import Foundation

@MainActor
final class ActivationViewModel: ObservableObject {
    @Published var isActivating: Bool = false
    private let activationService: ActivationServiceProtocol
    
    init(activationService: ActivationServiceProtocol) {
        self.activationService = activationService
    }
    
    func activate(code: String, onComplete: @escaping (Result<Void, Error>) -> Void) async {
        isActivating = true
        
        Task {
            do {
                let success = try await activationService.activate(code: code)
                
                await MainActor.run {
                    self.isActivating = false
                    if success {
                        onComplete(.success(()))
                    }
                }
            } catch {
                await MainActor.run {
                    self.isActivating = false
                    onComplete(.failure(error))
                }
            }
        }
        
    }
}
