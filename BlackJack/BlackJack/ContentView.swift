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
            Button(action: {CardGame.printDeck()}, label: {Text("Print Deck")})
            Button(action: {CardGame.drawCards(amount: 1)}, label: {Text("Draw A Card")})
            ScrollView{
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(CardGame.cards){ card in
                        VStack {
                            Text(card.suit)
                            Text(card.value)
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
