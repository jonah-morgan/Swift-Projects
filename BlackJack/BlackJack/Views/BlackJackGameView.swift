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
                        Spacer(minLength: 30)
                        PileOfCardsView(CardGame, type: "playersPile")
                        Spacer(minLength: 50)
                        if CardGame.hasLost{ TextView(string: "You lost $\(CardGame.betAmount)", color: .red) }
                        else if CardGame.hasWon { TextView(string: "You won $\(CardGame.betAmount)", color: .blue) }
                        else if CardGame.hasPushed { TextView(string: "You've pushed!", color: .red) }
                        else { HitStandView(model: CardGame) }
                        if !CardGame.hasContinued {
                            Button(action: {CardGame.resetGame()}, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20).frame(width: 100, height: 50, alignment: .center)
                                    Text("Continue").foregroundColor(.white)
                                }
                                
                                
                            } )
                        }
                    }
                } else if !CardGame.isDealing {
                    Spacer()
                    MoneyButtonLayoutView(CardGame, type: "buying")
                    MoneyButtonLayoutView(CardGame, type: "selling")
                    Spacer(minLength: 150)
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
                
                MoneyStatsView(CardGame.playerDollarAmount, CardGame.betAmount)
                    
            }
        }
        
    }
    
}











