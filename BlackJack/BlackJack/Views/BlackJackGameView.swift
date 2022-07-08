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
    
    
    var gameView: some View {
        ScrollView(.vertical){
            VStack {
                if CardGame.isDealing {
                    VStack{
                        PileOfCardsView(CardGame, type: "dealersPile")
                        Spacer(minLength: 20)
                        PileOfCardsView(CardGame, type: "playersPile")
                        if CardGame.hasLost{ TextView(string: "You lost $\(CardGame.betAmount)", color: .red) }
                        else if CardGame.hasWon { TextView(string: "You won $\(CardGame.betAmount)", color: .blue) }
                        else if CardGame.hasPushed { TextView(string: "You've pushed!", color: .red) }
                        HitStandView(model: CardGame)
                    }
                } else {
                    Spacer()
                    MoneyButtonLayoutView(CardGame, type: "buying")
                    MoneyButtonLayoutView(CardGame, type: "selling")
                    Spacer()
                    Button(action: {
                        if CardGame.betAmount >= CardGame.minBet {
                            CardGame.isDealing = true
                            CardGame.deal()
                        } else {
                            CardGame.isBelowMinimumBet = true
                        }
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(.blue)
                                .frame(width: 200, height: 100, alignment: .center)
                            Text("Deal").font(.largeTitle).foregroundColor(.white)
                        }
                    } )
                        .padding()
                    
                    if CardGame.isBelowMinimumBet {
                        TextView(string: "Minimum Bet: $\(CardGame.minBet)", color: .yellow)
                    }
                }
                Spacer()
                MoneyStatsView(CardGame.playerDollarAmount, CardGame.betAmount)
            }
        }
        
    }
    
}


struct TextView: View {
    let string: String
    let color: Color
    
    init(string: String, color: Color) {
        self.string = string
        self.color = color
    }
    
    
    var body: some View {
        Text(string)
            .font(.largeTitle)
            .foregroundColor(color)
    }
}


struct HitStandView: View {
    var model: CardGameModel
    
    
    init(model: CardGameModel) {
        self.model = model
    }
    
    var buttonRect: some View {
        RoundedRectangle(cornerRadius: 20)
            .padding()
            .frame(width: 150, height: 100, alignment: .center)
            .foregroundColor(.blue)
    }
    
    var body: some View {
        HStack {
            ZStack {
                buttonRect
                Button(action: {
                    model.hit()
                }, label: {
                    Text("Hit")
                        .foregroundColor(.yellow)
                }).font(.largeTitle)
            }
            ZStack {
                buttonRect
                Button(action: {
                    model.stand()
                }, label: {
                    Text("Stand")
                        .foregroundColor(.yellow)
                }).font(.largeTitle)
            }
        }
    }
}





