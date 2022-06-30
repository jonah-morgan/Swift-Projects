//
//  CardGameModel.swift
//  BlackJack
//
//  Created by Jonah Morgan on 6/30/22.
//

import Foundation
import SwiftUI

@MainActor class CardGameModel: ObservableObject {
    
    //figure out how to make images update on time!!!!!!
    
    private let drawCardURL = "https://deckofcardsapi.com/api/deck/<<deck_id>>/draw/?count="
    private let newDeckURL = "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1"
    private var newDeckCommunicator: DecodedDeck?
    
    private var deck: DecodedDeck?

    var pileOfCardsDictionary: [String:[Card]] = [
        "dealersPile": [],
        "playersPile": []
    ]
    private(set) var images: [UIImage] = []
    
    
    func newDeck() {
        let downloader = APICommunicator<DecodedDeck>(withUrl: newDeckURL)
        downloader.getData(completionBlock: {self.deck = $0})
    }
    
    func newPlayerPile(amount: Int) { drawCards(to: "playersPile", amount: 5) }
    func newDealerPile(amount: Int) { drawCards(to: "dealersPile", amount: 5) }
    
    @MainActor func drawCards(to thisPile: String, amount: Int) {
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
            
            for card in cards!{
                print("\(card)\n")
            }
            
            self.pileOfCardsDictionary[thisPile]! = cards!
            self.downloadImages(to: thisPile)
        })
        
    }
    
    @MainActor func downloadImages(to pile: String) {
        for index in 0..<pileOfCardsDictionary[pile]!.count {
            let downloader = APIImageDownloader(withUrl: pileOfCardsDictionary[pile]![index].image)
            downloader.getData(completionBlock: { self.pileOfCardsDictionary[pile]![index].uiImage = $0 })
        }
        
    }
    
    func printDeck() { if deck != nil { deck?.printInfo() } else { print("No Deck Information") } }
    
    private func convertToCard(from decodedCard: DecodedCard, with id: Int) -> Card {
        Card(id: id, code: decodedCard.code, image: decodedCard.image, value: decodedCard.value, suit: decodedCard.suit)
    }
    
    
    
    @MainActor struct APICommunicator<T: Codable> {
        let url: String
        init(withUrl url: String) {
            self.url = url
        }
        
        func getData(completionBlock: @escaping (T) -> Void) {
            
            let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error fetching data from Server")
                    return
                }
                
                var result: T?
                do {
                    try result = JSONDecoder().decode(T.self, from: data)
                    completionBlock(result!)
                } catch {
                    print("Failed to convert \(error.localizedDescription)")
                }
            }
            task.resume()
        }
        
    }


    @MainActor struct APIImageDownloader{
        let url: String
        init(withUrl url: String) {
            self.url = url
        }
        
        func getData(completionBlock: @escaping (UIImage) -> Void) {
            
            let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error fetching data from Server")
                    return
                }
                let result = UIImage(data: data)
                completionBlock(result!)
            }
            task.resume()
        }
        
    }

}
