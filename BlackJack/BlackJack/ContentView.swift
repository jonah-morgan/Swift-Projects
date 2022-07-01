//
//  ContentView.swift
//  BlackJack
//
//  Created by Jonah Morgan on 6/30/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var CardGame = CardGameModel()

    var body: some View {
        
        VStack {
            Button(action: {
                CardGame.newDeck()
            }, label: {Text("New Deck")})
            
            Button(action: {
                CardGame.printDeck()
            }, label: {Text("Print Deck")})
            
            Button(action: {
                CardGame.newPlayerPile(amount: 5)
                CardGame.printDeck()
            }, label: {Text("New Player Pile")})
            
            Button(action: {
                CardGame.newDealerPile(amount: 5)
                CardGame.printDeck()
            }, label: {Text("New Dealer Pile")})
            Button(action: {
                CardGame.makePileEmpty("playersPile")
            }, label: {Text("Empty Player Pile")})
            Button(action: {
                CardGame.makePileEmpty("dealersPile")
            }, label: {Text("Empty Dealers Pile")})
            
            HStack{
                ScrollView{
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                        ForEach(CardGame.pileOfCardsDictionary["playersPile"]!) { card in
                            if card.uiImage != nil {
                                Image(uiImage: card.uiImage!).frame(width: 50, height: 50, alignment: .center)
                            }
                        }
                    }
                }
                ScrollView{
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                        ForEach(CardGame.pileOfCardsDictionary["dealersPile"]!) { card in
                            if card.uiImage != nil {
                                Image(uiImage: card.uiImage!).frame(width: 50, height: 50, alignment: .center)
                            }
                            
                        }
                    }
                }
            }
            
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
