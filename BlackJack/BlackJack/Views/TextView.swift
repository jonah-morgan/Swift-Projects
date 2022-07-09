//
//  TextView.swift
//  BlackJack
//
//  Created by Jonah Morgan on 7/8/22.
//

import SwiftUI


struct TextView: View {
    let string: String
    let color: Color
    
    init(string: String, color: Color) {
        self.string = string
        self.color = color
    }
    
    
    var body: some View {
        Text(string)
            .font(.headline)
            .foregroundColor(color)
    }
}
