//
//  ScratchCardApp.swift
//  ScratchCard
//
//  Created by Marek Hajdučák on 03/11/2025.
//

import SwiftUI

@main
struct ScratchCardApp: App {
    @StateObject private var mainViewModel = MainViewModel(container: AppContainer.shared)
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainView(viewModel: mainViewModel)
            }
        }
    }
}
