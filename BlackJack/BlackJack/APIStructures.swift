//
//  APIStructures.swift
//  BlackJack
//
//  Created by Jonah Morgan on 6/30/22.
//

import Foundation
import SwiftUI

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


struct Card: Identifiable {
    let id: Int
    let code: String
    let image: String
    var uiImage: UIImage?
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
