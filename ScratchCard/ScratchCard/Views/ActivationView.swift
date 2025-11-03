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
    
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    private var code: String? {
        switch cardState {
        case .scratched(let code), .activated(let code):
            return code
        default:
            return nil
        }
    }
    
    private var canActivate: Bool {
        if case .scratched = cardState {
            return true
        }
        return false
    }
    
    init(
        viewModel: ActivationViewModel,
        cardState: ScratchCardState,
        onActivated: @escaping (String) -> Void,
        onError: @escaping (String) -> Void
    ) {
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
                    ProgressView("Activating...")
                } else {
                    Button("Activate Card") {
                        Task.detached(priority: .userInitiated) {
                            do {
                                try await viewModel.activate(code: code)
                                await MainActor.run {
                                    onActivated(code)
                                    dismiss()
                                }
                            } catch {
                                let message = error.localizedDescription
                                await MainActor.run {
                                    errorMessage = message
                                    showErrorAlert = true
                                    onError(message)
                                }
                            }
                        }
                    }
                    .disabled(!canActivate)
                    .buttonStyle(.borderedProminent)
                    .frame(height: 48)
                }
            } else {
                Text("No scratched code available")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .navigationTitle("Activation")
        .alert("Activation Failed", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        } message: {
            Text(errorMessage)
        }
    }
}
