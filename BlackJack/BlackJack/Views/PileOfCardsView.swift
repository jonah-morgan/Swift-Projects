//
//  PileOfCardsView.swift
//  BlackJack
//
//  Created by Jonah Morgan on 7/8/22.
//

import SwiftUI


struct PileOfCardsView: View {
    var type: String
    var typeUpdated = ""
    @ObservedObject var model: CardGameModel
    
    init(_ model: CardGameModel, type: String){
        self.type = type
        self.model = model
        
        if type == "dealersPile" {
            typeUpdated = "Dealer's"
        } else {
            typeUpdated = "Your"
        }
    }
    
    var body: some View {
        VStack {
            TextView(string: "\(typeUpdated) Pile", color: .yellow)
            HStack{
                ForEach(model.pileOfCards[type]!) { card in
                    if card.uiImage != nil {
                        Image(uiImage: card.uiImage!).frame(width: 75, height: 200, alignment: .top)
                    }
                }
            }
        }
        
    }
}
