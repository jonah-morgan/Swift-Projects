//
//  CardGameModel.swift
//  BlackJack
//
//  Created by Jonah Morgan on 6/30/22.
//

import Foundation
import SwiftUI

class CardGameModel: ObservableObject {
    private let drawCardURL = "https://deckofcardsapi.com/api/deck/<<deck_id>>/draw/?count="
    private let newDeckURL = "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1"
    private var newDeckCommunicator: DecodedDeck?
    
    private var deck: DecodedDeck?
    
    @Published var pileOfCardsDictionary: [String:[Card]] = [
        "dealersPile": [],
        "playersPile": []
    ]
    
    func newDeck() {
        let downloader = APICommunicator<DecodedDeck>(withUrl: newDeckURL)
        downloader.getData(completionBlock: {self.deck = $0})
    }
    
    func newPlayerPile(amount: Int) { drawCards(to: "playersPile", amount: 5) }
    
    func newDealerPile(amount: Int) { drawCards(to: "dealersPile", amount: 5) }
    
    func makePileEmpty(_ pile: String) {
        let emptyPile: [Card] = []
        pileOfCardsDictionary[pile]! = emptyPile
    }
    
    private func drawCards(to thisPile: String, amount: Int) {
        if self.deck!.remaining < amount { self.newDeck() }
        var cards = pileOfCardsDictionary[thisPile]
        
        var cardURL = drawCardURL
        cardURL = cardURL.replacingOccurrences(of: "<<deck_id>>", with: deck!.deck_id)
        cardURL += String(amount)
        
        let newCardCommunicator = APICommunicator<DecodedDrawnCards>(withUrl: cardURL)
        newCardCommunicator.getData( completionBlock: { newCards in
            
            for card in newCards.cards {
                let id: Int?
                if cards!.count == 0 { id = 0 } else { id = cards!.count }
                
                cards!.append(self.convertToCard(from: card, with: id!))
                self.deck!.remaining -= 1
            }
            
            DispatchQueue.main.async {
                self.pileOfCardsDictionary[thisPile]! = cards!
                self.downloadImages(to: thisPile)
            }
        })
        
    }
    
    
    func downloadImages(to pile: String) {
        for index in 0..<pileOfCardsDictionary[pile]!.count {
            let downloader = APIImageDownloader(withUrl: pileOfCardsDictionary[pile]![index].image)
            downloader.getData(completionBlock: { image in
                DispatchQueue.main.async {
                    self.pileOfCardsDictionary[pile]![index].uiImage = image
                }
                
            })
        }
    }
    
    
    func printDeck() { if deck != nil { deck?.printInfo() } else { print("No Deck Information") } }
    
    private func convertToCard(from decodedCard: DecodedCard, with id: Int) -> Card {
        Card(id: id, code: decodedCard.code, image: decodedCard.image, value: decodedCard.value, suit: decodedCard.suit)
    }
    

}
