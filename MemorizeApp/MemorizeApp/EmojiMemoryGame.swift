//
//  EmojiMemoryGame.swift
//  MemorizeApp
//
//  Created by Jonah on 6/9/22.
//

import SwiftUI





class EmojiMemoryGame: ObservableObject{
    
    @Published private var model = createMemoryGame(withTheme: emojiThemeArray[1])
    static var thisThemesName = emojiThemeArray[1].name
    
    var cards: Array<MemoryGame<String>.Card>{
        model.cards
    }
    
    var score = 0
    
    struct theme{
        var name: String
        var color: Color
        var numberOfPairs: Int
        var emojis: [String]
    }
    
    static let emojiThemeArray = [
        theme(name: "Faces", color: .green, numberOfPairs: 3, emojis:
                ["🥰","😌","😍","🧐","😌"]),
        theme(name: "Animals", color: .purple, numberOfPairs: 3, emojis:
                ["🐨", "🐰","🐶","🦁","🙉","🦋","🐻","🐶","🐔","🐤","🦄",]),
    ]
    
    func newGame() -> Void {
        score = 0
        let randomIndex = Int.random(in: 0..<EmojiMemoryGame.emojiThemeArray.count)
        model = EmojiMemoryGame.createMemoryGame(withTheme: EmojiMemoryGame.emojiThemeArray[randomIndex])
    }
    
    static func createMemoryGame(withTheme thisTheme: theme) -> MemoryGame<String> {
        let emojiArray = thisTheme.emojis.shuffled()
        var numberOfPairs = thisTheme.numberOfPairs
        thisThemesName = thisTheme.name
        
        if thisTheme.numberOfPairs > thisTheme.emojis.count{
            numberOfPairs = thisTheme.emojis.count
        }
        return MemoryGame<String>(numberOfPairsOfCards: numberOfPairs, color: thisTheme.color) { pairIndex in
            emojiArray[pairIndex]
        }
    }
    
    //MARK: - Intent(s)
    func choose(_ card: MemoryGame<String>.Card) {
        score = model.choose(card)
    }
    
}

