//
//  CardGameModel.swift
//  BlackJack
//
//  Created by Jonah Morgan on 6/30/22.
//

import SwiftUI

class CardGameModel: ObservableObject {
    init() {
        newDeck()
    }
    
    // Public
    @Published var pileOfCards: [String:[Card]] = [
        "dealersPile": [],
        "playersPile": []
    ]
    @Published var playerDollarAmount = 500
    @Published var betAmount = 0
    @Published var isDealing = false
    
    // work on figuring out values for when aces are involved
    // maybe an enumeration?
    private var playerPileValue: [Int] = []
    private var dealerPileValue: [Int] = []
    
    
    func deal() {
        drawCards(to: "playersPile", amount: 1)
        Thread.sleep(forTimeInterval: 0.1)
        drawCards(to: "dealersPile", amount: 1)
    }
    
    
    func hit() {
        drawCards(to: "playersPile", amount: 1)
    }
    
    
    func stand() {
        drawCards(to: "dealersPile", amount: 1)
    }
    
    
    func betMoney(amount: Int) {
        if amount <= playerDollarAmount {
            playerDollarAmount -= amount
            betAmount += amount
        }
    }
    
    
    func takeBackMoney(amount: Int) {
        if amount <= betAmount {
            playerDollarAmount += amount
            betAmount -= amount
        }
    }
    
    
    // Private
    private let drawCardURL = "https://deckofcardsapi.com/api/deck/<<deck_id>>/draw/?count="
    private let newDeckURL = "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1"
    private var deck: APIDeck?
    private let maxDrawSize: Int = 52
    
    private func newDeck() {
        let downloader = APIDataDownloader<APIDeck>(withUrl: newDeckURL)
        downloader.getData(completionBlock: { self.deck = $0 } )
    }
    
    
    private func convertToCard(from decodedCard: APICard, with id: Int) -> Card {
        Card(id: id, code: decodedCard.code, image: decodedCard.image, value: decodedCard.value, suit: decodedCard.suit)
    }
    
    
    private func downloadImages(to pile: String) {
        for index in 0..<pileOfCards[pile]!.count {
            let downloader = APIImageDownloader(withUrl: pileOfCards[pile]![index].image)
            downloader.getData(completionBlock: { image in
                DispatchQueue.main.async {
                    let newImage = self.resizeImage(image: image, targetSize: CGSize(width: 200, height: 200))
                    self.pileOfCards[pile]![index].uiImage = newImage
                }
                
            })
        }
    }
    
    
    private func drawCards(to thisPile: String, amount: Int) {
        if self.deck!.remaining < amount { self.newDeck() }
        if amount > maxDrawSize {
            print("not enough cards in deck")
            return
        }
        while self.deck!.remaining < amount {
            
        }
        var cards = pileOfCards[thisPile]
        var cardURL = drawCardURL
        cardURL = cardURL.replacingOccurrences(of: "<<deck_id>>", with: deck!.deck_id)
        cardURL += String(amount)
        
        let newCardCommunicator = APIDataDownloader<APIDrawnCards>(withUrl: cardURL)
        newCardCommunicator.getData( completionBlock: { newCards in
            
            for card in newCards.cards {
                let id: Int?
                if cards!.count == 0 { id = 0 } else { id = cards!.count }
                print(card.value)
                cards!.append(self.convertToCard(from: card, with: id!))
                self.deck!.remaining -= 1
            }
            DispatchQueue.main.async {
                self.pileOfCards[thisPile]! = cards!
                self.downloadImages(to: thisPile)
            }
        })
        
    }
    
    
    private func emptyPile(_ pile: String) {
        let emptyPile: [Card] = []
        pileOfCards[pile]! = emptyPile
    }
    
    
    private func printDeck() { if deck != nil { deck?.printInfo() } else { print("No Deck Information") } }
    
    
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(origin: .zero, size: newSize)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
