import Foundation
import SwiftUI

struct MemoryGame<CardContent> where CardContent: Equatable{
    
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter{ cards[$0].isFaceUp }.oneAndOnly }
        set { cards.indices.forEach{ cards[$0].isFaceUp = ($0 == newValue) }}
    }
    
    private(set) var score = 0
    
    struct Card: Identifiable{
        var isFaceUp = false
        var isMatched = false
        var previouslySeen = false
        let content: CardContent
        var color: Color
        let id: Int
    }
    
    private(set) var cards: Array<Card>
    
    mutating func choose(_ card: Card) -> Int{
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id}),
            !cards[chosenIndex].isFaceUp,
            !cards[chosenIndex].isMatched
        {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard{
                
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2
                } else if cards[chosenIndex].previouslySeen == true &&
                            cards[chosenIndex].content != cards[potentialMatchIndex].content{
                    score -= 1
                }
                cards[chosenIndex].previouslySeen = true
                cards[potentialMatchIndex].previouslySeen = true
            } else{
                
                for index in cards.indices{
                    cards[index].isFaceUp = false
                }
            }
            cards[chosenIndex].isFaceUp.toggle()
        }
        return score
    }
    
    
    init(numberOfPairsOfCards: Int, color: Color, createCardContent: (Int) -> CardContent) {
        cards = []
        
        for pairIndex in 0..<numberOfPairsOfCards{
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, color: color, id: pairIndex * 2))
            cards.append(Card(content: content, color: color, id: pairIndex * 2 + 1))
        }
        cards = cards.shuffled()
    }
    
}


extension Array {
    var oneAndOnly: Element? {
        if count == 1 { return first } else { return nil }
    }
}
