//
//  MemorizeAppApp.swift
//  MemorizeApp
//
//  Created by Jonah on 6/9/22.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(gameViewModel: game)
        }
    }
}
