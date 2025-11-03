//
//  MainView.swift
//  ScratchCard
//
//  Created by Marek Hajdučák on 03/11/2025.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        VStack(spacing: 20) {
            ZStack(alignment: .bottomLeading) {
                ZStack(alignment: .center) {
                    Image("Card")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(20)
                    VStack(spacing: 8) {
                        Text(viewModel.stateTitle)
                            .multilineTextAlignment(.center)
                            .font(.title2).bold()
                        Text("Scratch Card State: ")
                            .font(.caption)
                        + Text("\(viewModel.stateDescription)")
                            .bold()
                            .font(.caption)
                    }.padding(.horizontal, 16)
                }

                if let code = viewModel.code {
                    ScratchRevealView(code: code)
                        .padding(.horizontal, 16)
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.regularMaterial)
                        .frame(height: 60)
                        .padding(.horizontal, 32)
                        .padding(.bottom, 16)
                }
            }
            
            HStack {
                Spacer()
                NavigationLink("Scratch") {
                    ScratchView(
                        viewModel: viewModel.scratchViewModel,
                        onScratched: { code in
                            viewModel.updateState(.scratched(code: code))
                        }
                    )
                }
                .buttonStyle(.borderedProminent)
                .frame(height: 48)
                NavigationLink("Activate") {
                    ActivationView(
                        viewModel: viewModel.activationViewModel,
                        cardState: viewModel.card.state,
                        onActivated: { code in viewModel.updateState(.activated(code: code)) },
                        onError: { message in viewModel.updateState(.error(message)) }
                    )
                }
                .buttonStyle(.bordered)
                .frame(height: 48)
                Spacer()
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Your Scratch Card")
    }
}

struct ScratchRevealView: View {
    let code: String
    @State private var revealProgress: CGFloat = 0.0

    var body: some View {
        Text(code)
            .font(.caption)
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(.ultraThinMaterial)
            .cornerRadius(8)
            .mask(
                GeometryReader { geo in
                    Rectangle()
                        .frame(width: geo.size.width * revealProgress)
                        .animation(.easeInOut(duration: 1.8), value: revealProgress)
                }
            )
            .frame(height: 60)
        .padding()
        .onAppear {
            withAnimation {
                revealProgress = 1.0
            }
        }
    }
}
