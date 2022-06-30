//
//  CardGameModel.swift
//  BlackJack
//
//  Created by Jonah Morgan on 6/30/22.
//

import Foundation
import SwiftUI

@MainActor class CardGameModel: ObservableObject {
    
    private let drawCardURL = "https://deckofcardsapi.com/api/deck/<<deck_id>>/draw/?count="
    private let newDeckURL = "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1"
    private var newDeckCommunicator: DecodedDeck?
    
    private var deck: DecodedDeck?
    // figure out how to get cards drawn to these piles
    @Published private var pileOfCardsDictionary: [String:[Card]] = [
        "dealersPile": [],
        "playersPile": []
    ]
    private(set) var images: [UIImage] = []
    
    // work with these
    func newDeck() {
        let downloader = APICommunicator<DecodedDeck>(withUrl: newDeckURL)
        downloader.getData(completionBlock: {self.deck = $0})
    }
    
    
    func drawCards(to thisPile: String, amount: Int) {
        var cards = pileOfCardsDictionary[thisPile]
        
        var cardURL = drawCardURL
        cardURL = cardURL.replacingOccurrences(of: "<<deck_id>>", with: deck!.deck_id)
        cardURL += String(amount)
        
        let newCardCommunicator = APICommunicator<DecodedDrawnCards>(withUrl: cardURL)
        newCardCommunicator.getData( completionBlock: { newCards in
            
            for card in newCards.cards {
                let id: Int?
                if cards!.count == 0 { id = 0 } else { id = cards!.count }
                
                cards!.append(self.convertDecodedCard(from: card, with: id!))
                self.deck!.remaining -= 1
            }
            
            for card in cards!{
                print("\(card)\n")
            }
            
            self.pileOfCardsDictionary[thisPile]! = cards!
        })
        
    }
    
    
    func printDeck() { if deck != nil { deck?.printInfo() } else { print("No Deck Information") } }
    
    private func convertDecodedCard(from card: DecodedCard, with id: Int) -> Card {
        var newCard = Card(id: id, code: card.code, image: card.image, value: card.value, suit: card.suit)
        let downloader = APIImageDownloader(withUrl: card.image)
        downloader.getData { newCard.uiImage = $0 }
        return newCard
    }
    
}
