//
//  BlackJackApp.swift
//  BlackJack
//
//  Created by Jonah Morgan on 6/30/22.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var hasStarted = false
}


@main
struct BlackJackApp: App {
    @ObservedObject var viewController = AppState()
    
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
