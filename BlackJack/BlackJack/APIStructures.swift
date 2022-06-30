//
//  APIStructures.swift
//  BlackJack
//
//  Created by Jonah Morgan on 6/30/22.
//

import Foundation

struct DecodedDeck: Codable {
    
    let success: Bool
    let deck_id: String
    var remaining: Int
    var shuffled: Bool
    
    func printInfo() {
        print("Success: \(self.success)")
        print("ID: \(self.deck_id)")
        print("Remaining Cards: \(self.remaining)")
        print("Shuffled: \(self.shuffled)\n")
    }
}


struct DecodedCard: Codable {
    let code: String
    let image: String
    let value: String
    let suit: String
}


struct DecodedDrawnCards: Codable {
    let success: Bool
    let deck_id: String
    let cards: [DecodedCard]
    let remaining: Int
}
