//
//  MemoryGame.swift
//  MemorizeApp
//
//  Created by Jonah on 6/9/22.
//

import Foundation
import SwiftUI

struct MemoryGame<CardContent> where CardContent: Equatable{
    
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
    var score = 0
    
    struct Card: Identifiable{
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var color: Color
        var id: Int
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
                    score += 1
                }
                indexOfTheOneAndOnlyFaceUpCard = nil
            } else{
                for index in cards.indices{
                    cards[index].isFaceUp = false
                }
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp.toggle()
            
        }
        return score
    }
    
    
    init(numberOfPairsOfCards: Int, color: Color, createCardContent: (Int) -> CardContent){
        cards = Array<Card>()
        //add number of pairs of cards * 2 to cards array
        for pairIndex in 0..<numberOfPairsOfCards{
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, color: color, id: pairIndex * 2))
            cards.append(Card(content: content, color: color, id: pairIndex * 2 + 1))
        }
        cards = cards.shuffled()
    }
    
}
