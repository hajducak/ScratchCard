//
//  ScratchViewModel.swift
//  ScratchCard
//
//  Created by Marek Hajdučák on 03/11/2025.
//

import Foundation

@MainActor
final class ScratchViewModel: ObservableObject {
    @Published var isScratching = false
    private let scratchService: ScratchServiceProtocol
    private var task: Task<Void, Never>?
    
    init(scratchService: ScratchServiceProtocol) {
        self.scratchService = scratchService
    }
    
    func sratScratching(onComplete: @escaping (Result<String, Error>) -> Void) {
        isScratching = true
        task = Task {
            do {
                let code = try await scratchService.scratch()
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    self.isScratching = false
                    onComplete(.success(code))
                }
            } catch {
                await MainActor.run {
                    self.isScratching = false
                    onComplete(.failure(error))
                }
            }
        }
    }
    
    func cancelScratching() {
        task?.cancel()
        isScratching = false
    }
}
