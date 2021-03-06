//
//  MainMenuView.swift
//  BlackJack
//
//  Created by Jonah Morgan on 7/2/22.
//

import SwiftUI

struct MainMenuView: View {
    @EnvironmentObject var viewController: AppState
    
    var body: some View {
        VStack {
            Spacer()
            Text("Black Jack")
                .font(.largeTitle)
                .foregroundColor(.blue)
            ZStack {
                RoundedRectangle(cornerRadius: 100)
                    .foregroundColor(.green)
                    .frame(width: 100, height: 50, alignment: .center)
                Button(action: {
                    viewController.hasStarted = true
                }, label: {
                    Text("Play Game")
                        .foregroundColor(.yellow)
                })
            }
            Spacer()
            Text("* Requires internet to play")
            
        }
    }
}
