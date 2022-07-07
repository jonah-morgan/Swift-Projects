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
    @Published var hasLost = false
    @Published var hasWon = false
    @Published var isStanding = false
    
    
    func deal() {
        drawCards(to: "playersPile", amount: 1)
        drawCards(to: "dealersPile", amount: 1)
    }
    
    
    func hit() {
        if pileValues["playersPile"]![0] < 21{
            self.drawCards(to: "playersPile", amount: 1)
        }
    }
    
    
    func stand() {
        self.isStanding = true
        self.drawCards(to: "dealersPile", amount: 1)
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
    @Published private var pileValues = [
        "dealersPile": [0, 0],
        "playersPile": [0, 0]
    ]
    
    
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
        
        while self.deck!.remaining < amount {}
        
        var cards = pileOfCards[thisPile]
        var cardURL = drawCardURL
        cardURL = cardURL.replacingOccurrences(of: "<<deck_id>>", with: deck!.deck_id)
        cardURL += String(amount)
        
        let newCardCommunicator = APIDataDownloader<APIDrawnCards>(withUrl: cardURL)
        newCardCommunicator.getData( completionBlock: { [self] newCards in
            
            for card in newCards.cards {
                let id: Int?
                if cards!.count == 0 { id = 0 } else { id = cards!.count }
                cards!.append(self.convertToCard(from: card, with: id!))
                self.updateValue(for: thisPile, with: card)
                self.deck!.remaining -= 1
            }
            
            DispatchQueue.main.async {
                self.pileOfCards[thisPile]! = cards!
                self.checkIfWon()
                
                if !self.hasLost {
                    self.downloadImages(to: thisPile)
                } else if self.hasWon {
                    self.resetGame {
                        DispatchQueue.global(qos: .background).async {
                            Thread.sleep(forTimeInterval: 1.0)
                            self.playerDollarAmount += self.betAmount
                            DispatchQueue.main.async {
                                self.hasWon = false
                            }
                            
                        }
                        
                        
                    }
                }
                
                else if self.hasLost {
                    self.resetGame {
                        DispatchQueue.global(qos: .background).async {
                            Thread.sleep(forTimeInterval: 1.0)
                            DispatchQueue.main.async {
                                self.hasLost = false
                            }
                        }
                    }
                }
                
                else if self.isStanding{
                    // do something
                    if self.pileValues["dealersPile"]![0] <= 17{
                        DispatchQueue.global(qos: .background).async {
                            Thread.sleep(forTimeInterval: 1.0)
                            self.drawCards(to: "dealersPile", amount: 1)
                        }
                        
                    }
                }
            }
        })
        
    }
    
    
    private func updateValue(for pile: String, with card: APICard) {
        switch card.value {
        case "ACE":
            pileValues[pile]![0] += 1
            pileValues[pile]![1] += 11
            
        case "KING", "QUEEN", "JACK":
            pileValues[pile]![0] += 10
            pileValues[pile]![1] += 10
            
        default:
            pileValues[pile]![0] += Int(card.value)!
            pileValues[pile]![1] += Int(card.value)!
        }
    }
    
    
    private func emptyValues() {
        self.pileValues["playersPile"] = [0, 0]
        self.pileValues["dealersPile"] = [0, 0]
    }
    
        
    private func resetGame( completionHandler: @escaping () -> Void) {
        DispatchQueue.main.async {
            self.emptyValues()
            self.pileOfCards["playersPile"]! = []
            self.pileOfCards["dealersPile"]! = []
            self.isDealing = false
            self.isStanding = false
        }
        completionHandler()
        self.betAmount = 0
    }
    
    
    private func checkIfWon() {
        let pVals = pileValues["playersPile"]!
        let dVals = pileValues["dealersPile"]!
        
        let maxPValue = max( pVals[0], pVals[1] )
        let maxDValue = max( dVals[0], dVals[1] )
        // player busted
        if pVals[0] > 21 {
            self.hasLost = true
        }
        // dealer busted
        else if dVals[0] > 21 {
            self.hasWon = true
        }
        // both dealers values are higher
        else if self.isStanding && maxDValue > maxPValue {
            self.hasLost = true
        }
        // dealer is above 17 and is still lower than the player
        else if self.isStanding && dVals[0] > 17 &&
                    maxDValue < maxPValue {
            self.hasWon = true
        }
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
