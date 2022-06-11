//
//  ContentView.swift
//  Memorize
//
//  Created by Jonah Morgan on 6/5/22.
//

import SwiftUI

struct memorizeView: View {
    
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack{
            Text("Memorize some \(EmojiMemoryGame.thisThemesName)!")
                .foregroundColor(.yellow)
                .padding(.pi)
                .font(.title)
            ScrollView{
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))]) {
                    ForEach(viewModel.cards){ card in
                        CardView(card: card)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture{
                                viewModel.choose(card)
                            }
                    }
                }
            }
            .padding(.horizontal)
            HStack{
                newGameButton
                Spacer()
                Text("Score: \(viewModel.score)")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal)
        .font(.largeTitle)
    }
    
    var newGameButton: some View {
        Button(action: {
            viewModel.newGame()
        }, label: {
            ZStack{
                RoundedRectangle(cornerRadius: 20).aspectRatio(3/1, contentMode: .fit)
                    .foregroundColor(.mint)
                    .frame(width: 150, height: 70, alignment: .center)
                Text("New Game")
                    .foregroundColor(.blue)
                    .font(.title3)
                    .padding()
            }
            
        })
    }
    
}
 

struct CardView: View{
    
    let card:MemoryGame<String>.Card
    let myRect = RoundedRectangle(cornerRadius: 20)
    
    var body: some View{
        ZStack{
            if card.isFaceUp{
                myRect.fill().foregroundColor(.white)
                myRect.strokeBorder(lineWidth: 5)
                Text(card.content).font(.largeTitle)
            } else if card.isMatched{
                myRect.opacity(0)
            } else{
                myRect.fill()
                Text(" ").font(.largeTitle)
            }
        }.foregroundColor(card.color)
    }
    
}
  



















struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let game = EmojiMemoryGame()
        
        memorizeView(viewModel: game)
            .preferredColorScheme(.light)
            .previewInterfaceOrientation(.landscapeLeft)
        
        memorizeView(viewModel: game)
            .preferredColorScheme(.dark)
        
    }
}
