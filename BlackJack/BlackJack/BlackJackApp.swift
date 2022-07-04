//
//  BlackJackApp.swift
//  BlackJack
//
//  Created by Jonah Morgan on 6/30/22.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var hasStarted = false
    @Published var isDealing = false
}


@main
struct BlackJackApp: App {
    @ObservedObject var viewController = AppState()
    var dollarAmount = 0
    
    var body: some Scene {
        WindowGroup {
            if viewController.hasStarted {
                BlackJackGameView()
                    .environmentObject(viewController)
            } else {
                MainMenuView()
                    .environmentObject(viewController)
            }
            
        }
    }
}
