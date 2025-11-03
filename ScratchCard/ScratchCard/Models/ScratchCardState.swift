//
//  ScratchCardState.swift
//  O2ScratchCard
//
//  Created by Marek Hajdučák on 03/11/2025.
//


import Foundation

enum ScratchCardState: Equatable {
    case unscratched
    case scratching
    case scratched(code: String)
    case activating(code: String)
    case activated(code: String)
    case error(String)
}
