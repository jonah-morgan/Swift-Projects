import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var gameViewModel = EmojiMemoryGame()
    
    var body: some View {
        VStack{
            Text("Memorize some " + gameViewModel.getName() + "!")
                .foregroundColor(.yellow)
                .padding(.pi)
                .font(.title)
                
            ScrollView{
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(gameViewModel.cards){ card in
                        CardView(card: card)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture{ gameViewModel.choose(card) }
                    }
                }
            }
            .padding(.horizontal)
            HStack{
                newGameButton
                Spacer()
                scoreText
            }
        }
        .padding(.horizontal)
        .font(.largeTitle)
    }
    
    var newGameButton: some View {
        Button( action: {gameViewModel.newGame()} ) {
            ZStack{
                RoundedRectangle(cornerRadius: 20).aspectRatio(3/1, contentMode: .fit)
                    .foregroundColor(.mint)
                    .frame(width: 120, height: 70, alignment: .center)
                Text("New Game")
                    .foregroundColor(.blue)
                    .font(.title3)
                    .padding()
            }
            
        }
    }
    
    var scoreText: some View{
        Text("Score: " + String(gameViewModel.score))
            .font(.title2)
            .foregroundColor(.blue)
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
                Pie(
                    startAngle: Angle(degrees: 270),
                    endAngle: Angle(degrees: 45))
                .opacity(0.5).padding(7)
                Text(card.content).font(Font.system(size: 70))
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
        game.choose(game.cards.first!)
        return  EmojiMemoryGameView(gameViewModel: game)
            .preferredColorScheme(.light)
            .previewInterfaceOrientation(.landscapeLeft)
        
    }
}
