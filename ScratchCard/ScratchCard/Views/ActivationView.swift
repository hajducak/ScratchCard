//
//  ActivationView.swift
//  ScratchCard
//
//  Created by Marek Hajdučák on 03/11/2025.
//

import SwiftUI

struct ActivationView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var viewModel: ActivationViewModel
    let cardState: ScratchCardState
    let onActivated: (String) -> Void
    let onError: (String) -> Void
    
    private var code: String? {
        if case .scratched(let code) = cardState {
            return code
        } else if case .activated(let code) = cardState {
            return code
        } else { return nil }
    }
    
    init(viewModel: ActivationViewModel, cardState: ScratchCardState, onActivated: @escaping (String) -> Void, onError: @escaping (String) -> Void) {
        self.viewModel = viewModel
        self.cardState = cardState
        self.onActivated = onActivated
        self.onError = onError
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if let code = code {
                Text("Code: \(code)")
                    .font(.headline)
                
                if viewModel.isActivating {
                    ProgressView("Activationg...")
                } else {
                    Button("Activate Card") {
                        Task {
                            await viewModel.activate(code: code) { result in
                                switch result {
                                case .success:
                                    onActivated(code)
                                    dismiss()
                                case .failure(let error):
                                    onError(error.localizedDescription)
                                }
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(height: 48)
                }
            } else {
                Text("No scratched cade available")
                    .foregroundColor(.gray)
            }
        }
        .padding()
                .navigationTitle("Activation")
    }
}
