//
//  ContentView.swift
//  BlackJack
//
//  Created by Jonah Morgan on 6/30/22.
//

import SwiftUI

struct BlackJackGameView: View {
    @ObservedObject var CardGame = CardGameModel()
    
    var body: some View {
        gameView
    }
    
    var rect: some View {
        RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.yellow)
                    .frame(width: 100, height: 50, alignment: .center)
    }
    
    
    var gameView: some View {
        VStack {
            if CardGame.isDealing {
                VStack{
                    pileOfCardsView(CardGame, type: "dealersPile")
                    Spacer(minLength: 20)
                    pileOfCardsView(CardGame, type: "playersPile")
                }
            } else {
                Button(action: {
                    CardGame.deal()
                    CardGame.isDealing = true
                }, label: {Text("Deal").font(.largeTitle)} )
                    .padding()
                moneyButtonLayout(CardGame, type: "buying")
                moneyButtonLayout(CardGame, type: "selling")
            }
            Spacer()
            moneyStatsView
        }
    }
    
    var moneyStatsView: some View {
        HStack {
            Text("Your $: \(CardGame.playerDollarAmount)")
            Spacer()
            Text("Bet $: \(CardGame.betAmount)")
        }
            .font(.largeTitle)
            .foregroundColor(.green)
    }
}


struct pileOfCardsView: View {
    var type: String
    @ObservedObject var model: CardGameModel
    
    init(_ model: CardGameModel, type: String){
        self.type = type
        self.model = model
    }
    
    var body: some View {
        HStack{
            ForEach(model.pileOfCards[type]!) { card in
                if card.uiImage != nil {
                    Image(uiImage: card.uiImage!).frame(width: 150, height: 200, alignment: .center)
                }
            }
        }.padding()
    }
}


struct moneyButtonLayout: View {
    var type: String
    @ObservedObject var model: CardGameModel
    
    init(_ model: CardGameModel, type: String){
        self.type = type
        self.model = model
    }
    
    var amounts = [1, 5, 10, 50, 100]
    
    var body: some View {
        HStack {
            ForEach(amounts, id: \.self) { amount in
                if model.playerDollarAmount >= amount {
                    Button(action: {
                        if self.type == "buying" {
                            model.betMoney(amount: amount)
                        } else {
                            model.takeBackMoney(amount: amount)
                        }
                        
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
}


