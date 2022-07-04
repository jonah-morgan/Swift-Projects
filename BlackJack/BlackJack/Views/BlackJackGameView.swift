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
        ZStack {
            Color.green.ignoresSafeArea()
            gameView
        }
        
    }
    
    var buttonRect: some View {
        RoundedRectangle(cornerRadius: 20)
            .padding()
            .frame(width: 150, height: 100, alignment: .center)
            .foregroundColor(.blue)
    }
    
    var gameView: some View {
        VStack {
            if CardGame.isDealing {
                VStack{
                    pileOfCardsView(CardGame, type: "dealersPile")
                    Spacer(minLength: 20)
                    pileOfCardsView(CardGame, type: "playersPile")
                    hitStandView
                }
            } else {
                Button(action: {
                    CardGame.deal()
                    CardGame.isDealing = true
                }, label: {Text("Deal").font(.largeTitle)} )
                    .padding()
                Text("Your Chips").font(.largeTitle)
                moneyButtonLayout(CardGame, type: "buying")
                Text("Dealer Chips").font(.largeTitle)
                moneyButtonLayout(CardGame, type: "selling")
            }
            Spacer()
            moneyStatsView
        }
    }
    
    var hitStandView: some View {
        HStack {
            ZStack {
                buttonRect
                Button(action: {
                    CardGame.hit()
                }, label: {
                    Text("Hit")
                        .foregroundColor(.yellow)
                }).font(.largeTitle)
            }
            ZStack {
                buttonRect
                Button(action: {
                    CardGame.stand()
                }, label: {
                    Text("Stand")
                        .foregroundColor(.yellow)
                }).font(.largeTitle)
            }
        }
    }
    
    var moneyStatsView: some View {
        HStack {
            Text("Your $: \(CardGame.playerDollarAmount)")
            Spacer()
            Text("Bet $: \(CardGame.betAmount)")
        }
            .font(.largeTitle)
            .foregroundColor(.yellow)
            .padding()
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
                    Image(uiImage: card.uiImage!).frame(width: 100, height: 200, alignment: .center)
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
    
    let amounts = [1, 5, 10, 50, 100]
    let index = [ 0, 1, 2, 3, 4 ]
    let colors: [Color] = [.gray, .red, .indigo, .blue, .pink]
    
    var body: some View {
        HStack {
            ForEach(index, id: \.self) { index in
                Button(action: {
                    if self.type == "buying" {
                        model.betMoney(amount: amounts[index])
                    } else {
                        model.takeBackMoney(amount: amounts[index])
                    }
                    
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                                    .foregroundColor(colors[index])
                                    .frame(width: 50, height: 50, alignment: .center)
                        Text(String(amounts[index])).foregroundColor(.yellow)
                    }
                })
            }
        }
    }
}


