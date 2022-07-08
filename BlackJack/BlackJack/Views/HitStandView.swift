//
//  HitStandView.swift
//  BlackJack
//
//  Created by Jonah Morgan on 7/8/22.
//

import SwiftUI


struct HitStandView: View {
    var model: CardGameModel
    
    
    init(model: CardGameModel) {
        self.model = model
    }
    
    var buttonRect: some View {
        RoundedRectangle(cornerRadius: 20)
            .padding()
            .frame(width: 150, height: 100, alignment: .center)
            .foregroundColor(.blue)
    }
    
    var body: some View {
        HStack {
            ZStack {
                buttonRect
                Button(action: {
                    model.hit()
                }, label: {
                    Text("Hit")
                        .foregroundColor(.yellow)
                }).font(.largeTitle)
            }
            ZStack {
                buttonRect
                Button(action: {
                    model.stand()
                }, label: {
                    Text("Stand")
                        .foregroundColor(.yellow)
                }).font(.largeTitle)
            }
        }
    }
}
