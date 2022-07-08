//
//  MoneyViews.swift
//  BlackJack
//
//  Created by Jonah Morgan on 7/8/22.
//
import SwiftUI

struct MoneyStatsView: View {
    var firstAmount: Int
    var secondAmount: Int
    
    init(_ firstAmount: Int, _ secondAmount: Int)
    {
        self.firstAmount = firstAmount
        self.secondAmount = secondAmount
    }
    
    var rect: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(.black)
            .frame(width: 180, height: 50, alignment: .center)
            .padding(.vertical)
    }
    
    var body: some View {
        HStack {
            ZStack {
                rect
                Text("Your Account: $\(firstAmount)")
            }
            
            Spacer()
            
            ZStack {
                rect
                Text("Bet Amount: $\(secondAmount)")
            }
            
        }
        .font(.body)
            .foregroundColor(.yellow)
            .padding(.all)
    }
    
}


struct MoneyButtonLayoutView: View {
    var type: String
    var typeUpdated = ""
    @ObservedObject var model: CardGameModel
    
    init(_ model: CardGameModel, type: String){
        self.type = type
        self.model = model
        
        if type == "selling" {
            typeUpdated = "Lower"
        } else {
            typeUpdated = "Increase"
        }
    }
    
    let amounts = [1, 5, 10, 50, 100, 1000]
    let index = [ 0, 1, 2, 3, 4, 5 ]
    let colors: [Color] = [.gray, .red, .indigo, .blue, .pink, .black]
    
    var body: some View {
        VStack {
            Text("\(typeUpdated) Bet")
                .font(.largeTitle)
                .foregroundColor(.yellow)
            HStack {
                ForEach(index, id: \.self) { index in
                    Button(action: {
                        if self.type == "buying" {
                            model.betMoney(amount: amounts[index])
                        } else {
                            model.takeBackMoney(amount: amounts[index])
                        }
                        
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                        .foregroundColor(colors[index])
                                        .frame(width: 50, height: 50, alignment: .center)
                            Text(String(amounts[index])).foregroundColor(.yellow)
                        }
                    })
                }
            }
        }

    }
}


