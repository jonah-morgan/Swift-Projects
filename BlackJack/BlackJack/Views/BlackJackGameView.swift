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
        if viewController.isDealing {
            gameView
        } else {
            betView
        }
        
    }
    
    var betView: some View {
        VStack{
            bettingButtonLayout
            Button(action: {
                CardGame.deal()
            }, label: {
                Text("Deal")
            }).padding()
            Button(action: {
                viewController.isDealing = true
            }, label: {
                Text("Play")
                // why are the piles resetting after switching to the betView?
            }).padding()
            HStack {
                Text("$ Amount: \(CardGame.playerDollarAmount)")
                    .padding()
                    .foregroundColor(.blue)
                Spacer()
                Text("Bet Amount: \(CardGame.betAmount)")
                    .padding()
                    .foregroundColor(.blue)
            }.padding()
        }
        
    }
    
    var bettingAmount = [1, 5, 10, 50, 100]
    var bettingButtonLayout: some View {
        HStack {
            ForEach(bettingAmount, id: \.self) { amount in
                if CardGame.playerDollarAmount >= amount {
                    Button(action: {
                        CardGame.betMoney(amount: amount)
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(.yellow)
                                .frame(width: 50, height: 50, alignment: .center)
                            Text(String(amount))
                        }
                    })
                }
            }
        }
    }
    
    
    var gameView: some View {
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
    
    
}


