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
    
    // Public Variables and Functions
    @Published var pileOfCards: [String:[Card]] = [
        "dealersPile": [],
        "playersPile": []
    ]
    @Published var playerDollarAmount = 10000
    @Published var betAmount = 0
    @Published var isDealing = false
    @Published var hasLost = false
    @Published var hasWon = false
    @Published var isStanding = false
    @Published var hasPushed = false
    @Published var isBelowMinimumBet = false
    let minBet = 5
    
    
    func deal() {
        drawCards(to: "playersPile", amount: 1)
        Thread.sleep(forTimeInterval: 0.4)
        drawCards(to: "dealersPile", amount: 1)
    }
    
    
    func hit() {
        if pileValues["playersPile"]![0] < 21{
            self.drawCards(to: "playersPile", amount: 1)
        }
    }
    
    
    func stand() {
        if !self.isStanding{
            self.isStanding = true
            self.drawCards(to: "dealersPile", amount: 1)
        }
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
    
    
    // Private Variables and Functions
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
        downloader.getData(completionHandler: { self.deck = $0 } )
    }
    
    
    private func convertToCard(from decodedCard: APICard, with id: Int) -> Card {
        Card(id: id, code: decodedCard.code, image: decodedCard.image, value: decodedCard.value, suit: decodedCard.suit)
    }
    
    
    private func downloadImages(to pile: String) {
        for index in 0..<pileOfCards[pile]!.count {
            let downloader = APIImageDownloader(withUrl: pileOfCards[pile]![index].image)
            
            downloader.getData(completionBlock: { image in
                DispatchQueue.main.async {
                    let newImage = self.resizeImage(image: image, targetSize: CGSize(width: 175, height: 175))
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
        
        newCardCommunicator.getData( completionHandler: { [self] newCards in
            // After downloading card data. Update the card array for this pile.
            for card in newCards.cards {
                let id: Int?
                if cards!.count == 0 { id = 0 } else { id = cards!.count }
                cards!.append(self.convertToCard(from: card, with: id!))
                self.updateValue(for: thisPile, with: card)
                self.deck!.remaining -= 1
            }
            
            DispatchQueue.main.async {
                self.fixValuesWithAces(for: thisPile)
                self.pileOfCards[thisPile]! = cards!
                self.checkIfWon()
                self.downloadImages(to: thisPile)
                
                if self.hasLost {
                    self.resetGame { }
                } else if self.hasWon {
                    self.resetGame { self.playerDollarAmount += 2 * self.betAmount }
                } else if self.hasPushed {
                    self.resetGame { self.playerDollarAmount += self.betAmount }
                }
                
                else if self.isStanding{
                    if self.pileValues["dealersPile"]![0] <= 17{
                        DispatchQueue.global(qos: .background).async {
                            Thread.sleep(forTimeInterval: 1.0)
                            // Recursive call if the player pressed the 'Stand' Button
                            self.drawCards(to: "dealersPile", amount: 1)
                        }
                    }
                } else if self.pileValues[thisPile]![0] == 21 ||
                            self.pileValues[thisPile]![1] == 21 {
                    self.stand()
                }
            }
        })
        
    }
    
    
    private func fixValuesWithAces(for pile: String) {
        if pileValues[pile]![1] > 21 {
            var aceCount = 0
            for card in pileOfCards[pile]! {
                if card.value == "ACE" { aceCount += 1 }
            }
            if aceCount > 0 { pileValues[pile]![1] -= 10 }
        }
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
    
        
    private func resetGame(completionHandler: @escaping () -> Void ) {
        completionHandler()
        
        DispatchQueue.global(qos: .background).async {
            Thread.sleep(forTimeInterval: 2.0)
            DispatchQueue.main.async {
                self.pileValues["playersPile"] = [0, 0]
                self.pileValues["dealersPile"] = [0, 0]
                self.pileOfCards["playersPile"]! = []
                self.pileOfCards["dealersPile"]! = []
                self.betAmount = 0
                self.hasWon = false
                self.hasLost = false
                self.hasPushed = false
                self.isDealing = false
                self.isStanding = false
                self.isBelowMinimumBet = false
            }
        }
    }
    
    
    private func checkIfWon() {
        let pVals = self.pileValues["playersPile"]!
        let dVals = self.pileValues["dealersPile"]!
        
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
        // if the player and the dealer push
        else if self.isStanding && dVals[0] > 17 &&
                    maxPValue == maxDValue {
            self.hasPushed = true
        }
    }
    
    
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
    
    
    private func printValues() {
        print("Dealers Values:")
        for value in pileValues["dealersPile"]! {
            print(value)
        }
        print("\n")
        print("Players Values:")
        for value in pileValues["playersPile"]! {
            print("\(value)")
        }
        print("\n")
    }
}
