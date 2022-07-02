//
//  BlackJackApp.swift
//  BlackJack
//
//  Created by Jonah Morgan on 6/30/22.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var hasStarted: Bool
    @Published var isDealing: Bool
    
    init(hasStarted: Bool){
        self.hasStarted = hasStarted
    }
}


@main
struct BlackJackApp: App {
    @ObservedObject var viewController = AppState(hasStarted: false)
    
    var body: some Scene {
        WindowGroup {
            if viewController.hasStarted {
                if viewController.isDealing {
                    BlackJackGameView()
                        .environmentObject(viewController)
                } else {
                    BetMenuView()
                        .environmentObject(viewController)
                }
                
            } else {
                MainMenuView()
                    .environmentObject(viewController)
            }
            
        }
    }
}
