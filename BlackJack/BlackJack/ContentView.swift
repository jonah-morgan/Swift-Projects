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
            Button(action: {CardGame.downloadImage(from: CardGame.cards[0].image)}, label: {Text("Download Picture")})
            ScrollView{
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(CardGame.cards){ card in
                        VStack {
                            Text(card.suit)
                            Text(card.value)
                        }
                    }
                }
                if CardGame.images.count > 0 {
                    Image(uiImage: CardGame.images[0])
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
