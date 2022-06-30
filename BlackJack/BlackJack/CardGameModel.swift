//
//  CardGameModel.swift
//  BlackJack
//
//  Created by Jonah Morgan on 6/30/22.
//

import Foundation
import SwiftUI

@MainActor class CardGameModel: ObservableObject {
    
    private static let newDeckURL = "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1"
    private let drawCardURL = "https://deckofcardsapi.com/api/deck/<<deck_id>>/draw/?count="
    
    private var newDeckCommunicator = APICommunicator<DecodedDeck>(withUrl: newDeckURL)
    private var deck: DecodedDeck?
    @Published private(set) var cards: [Card] = []
    var id = 0
    
    
    func newDeck() { newDeckCommunicator.getData { newDeck in
            self.deck = newDeck
        }
    }
    
    
    func drawCards(amount: Int) {
        var modifiedURL = drawCardURL
        modifiedURL = modifiedURL.replacingOccurrences(of: "<<deck_id>>", with: deck!.deck_id)
        modifiedURL += String(amount)
        
        let newCardCommunicator = APICommunicator<DecodedDrawnCards>(withUrl: modifiedURL)
        
        newCardCommunicator.getData(completionBlock: { newCards in
            for card in newCards.cards {
                self.cards.append(self.convertDecodedCard(from: card, with: self.id))
                self.id += 1
            }
            for card in self.cards{
                print("\(card)\n")
            }
            self.deck!.remaining -= amount
        })
        
    }
    
    
    func printDeck() {
        if deck != nil {
            deck?.printInfo()
        } else {
            print("No Deck Information")
        }
    }
    
    private func convertDecodedCard(from card: DecodedCard, with id: Int) -> Card {
        return Card(id: id, code: card.code, image: card.image, value: card.value, suit: card.suit)
    }
    
    
    struct Card: Identifiable {
        var id: Int
        let code: String
        let image: String
        let value: String
        let suit: String
        
        init(id: Int, code: String, image: String, value: String, suit: String) {
            self.id = id
            self.code = code
            self.image = image
            self.value = value
            self.suit = suit
        }
        
    }
    
}
