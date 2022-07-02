//
//  ContentView.swift
//  BlackJack
//
//  Created by Jonah Morgan on 6/30/22.
//

import SwiftUI

struct BlackJackGameView: View {
    @ObservedObject var CardGame = CardGameModel()
    @EnvironmentObject var viewController: AppState
    
    var body: some View {
        
        VStack {
            
            VStack{
                ScrollView(.horizontal){
                    HStack{
                        ForEach(CardGame.pileOfCards["playersPile"]!) { card in
                            if card.uiImage != nil {
                                Image(uiImage: card.uiImage!).frame(width: 100, height: 200, alignment: .center)
                            }
                        }
                    }
                }
                ScrollView(.horizontal){
                    HStack{
                        ForEach(CardGame.pileOfCards["dealersPile"]!) { card in
                            if card.uiImage != nil {
                                Image(uiImage: card.uiImage!).frame(width: 100, height: 200, alignment: .center)
                            }
                        }
                    }
                }
            }
        }
        Spacer()
        HStack{
            Button(action: { CardGame.deal() }, label: {Text("Deal").font(.largeTitle)} )
                .padding()
            Spacer()
            Button(action: { CardGame.deal() }, label: {Text("Bet").font(.largeTitle)} )
                .padding()
            
        }
       
        
    }
    
}


