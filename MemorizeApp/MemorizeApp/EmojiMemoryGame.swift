import SwiftUI



class EmojiMemoryGame: ObservableObject{
    typealias Card = MemoryGame<String>.Card
    
    @Published private var model = createMemoryGame(withTheme: getRandomTheme())
    private(set) static var themeName: String?
    private(set) var score = 0
    
    
    var cards: [Card] {
        model.cards
    }
    
    
    struct theme{
        var name: String
        var color: Color
        var numberOfPairs: Int
        var emojis: [String]
    }
    
    
    static let emojiThemeArray = [
        theme(name: "Faces", color: .green, numberOfPairs: 20, emojis:
                ["🥰","😌","😍","🧐","🥸"]),
        theme(name: "Animals", color: .purple, numberOfPairs: 7, emojis:
                ["🐨", "🐰","🪳","🦁","🙉","🦋","🐻","🐶","🐔","🐤","🦄",]),
        theme(name: "Vehicles", color: .blue, numberOfPairs: 10, emojis:
                ["🚌","🚙","🚗","🚒","🚕","🏎","🚓","🚛"]),
        theme(name: "Devices", color: .red, numberOfPairs: 12, emojis:
                ["💻","⌚️","📷","📱","🖥","🖨","🎥","☎️","📺"])
    ]
    
    
    static func getRandomTheme() -> theme{
        let randomIndex = Int.random(in: 0..<emojiThemeArray.count)
        themeName = emojiThemeArray[randomIndex].name
        return emojiThemeArray[randomIndex]
    }
    
    func newGame() -> Void {
        score = 0
        let newTheme = EmojiMemoryGame.getRandomTheme()
        model = EmojiMemoryGame.createMemoryGame(withTheme: newTheme)
    }
    
    static func createMemoryGame(withTheme thisTheme: theme) -> MemoryGame<String> {
        let emojiArray = thisTheme.emojis.shuffled()
        print(emojiArray)
        var pairAmount = thisTheme.numberOfPairs
        
        if pairAmount > thisTheme.emojis.count{
            pairAmount = thisTheme.emojis.count
        }
        
        return MemoryGame<String>(numberOfPairsOfCards: pairAmount, color: thisTheme.color) { pairIndex in
            emojiArray[pairIndex]
        }
    }
    
    //MARK: - Intent(s)
    func choose(_ card: Card) {
        score = model.choose(card)
    }
    
    
    func getName() -> String{
        EmojiMemoryGame.themeName!
    }
    
}

