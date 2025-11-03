//
//  ScratchView.swift
//  ScratchCard
//
//   Created by Marek Hajdučák on 03/11/2025.
//

import SwiftUI

struct ScratchView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var viewModel: ScratchViewModel
    let onScratched: (String) -> Void
    
    init(viewModel: ScratchViewModel, onScratched: @escaping (String) -> Void) {
        self.viewModel = viewModel
        self.onScratched = onScratched
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if viewModel.isScratching {
                ProgressView("Scratching...")
            } else {
                Button("Scratch Card") {
                    viewModel.startScratching { result in
                        switch result {
                        case .success(let code):
                            onScratched(code)
                            dismiss()
                        case .failure(let error):
                            print("Scratch failed: \(error.localizedDescription)")
                        
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .frame(height: 48)
            }
        }
        .padding()
        .navigationTitle("Scratching")
        .onDisappear {
            if viewModel.isScratching {
                viewModel.cancelScratching()
            }
        }
    }
}
