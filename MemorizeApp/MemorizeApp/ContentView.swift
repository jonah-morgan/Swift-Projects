//
//  ContentView.swift
//  Memorize
//
//  Created by Jonah Morgan on 6/5/22.
//

import SwiftUI

let cardColor: Color = .red; let facesColor: Color = .yellow
let animalsColor: Color = .orange; let foodColor: Color = .indigo
let initialCardAmount = 0; let initialThemeType = 0


func randomizeThis(_ array: [String]) -> [String]{
    array.shuffled()
}



struct memorizeView: View {
    
    @State var usingArray : [String] = ["1"]
    @State var themeType = initialThemeType
    @State var cardCount = initialCardAmount
    
    let themeArray = [["🥰", "😌","😍","🧐","😌","😍","🧐","😌","😍",
                        "🧐","😌","😍","🧐","😌","😍","🧐"],
                      
                     ["🐵","🪲","🦊","🐵","🪲","🦊","🐵","🪲","🦊",
                        "🐵","🪲","🦊","🐵","🪲","🦊",],
                      
                     ["🌶","🥝","🍆","🌶","🥝","🍆","🌶","🥝","🍆",
                        "🌶","🥝","🍆","🌶","🥝","🍆","🌶","🥝","🍆"]]
    
    var themeDict = [ "faces": (0, "face.smiling.fill", facesColor),
                      "animals": (1,"heart.fill", animalsColor),
                      "food": (2,"fork.knife", foodColor) ]
    
    
    var removeButton: some View{
        Button(action: {
            if cardCount > 0{
                cardCount -= 1
            }
        }, label: {Image(systemName: "minus.circle")})
    }
    
    
    var appendButton: some View{
        Button(action: {
            if cardCount < themeArray[themeType].count{
                cardCount += 1
            }
        }, label: {Image(systemName: "plus.circle")})
    }
    
    
    func themeButton(_ type: String) -> some View{
        var thisButton: some View{
            Button(action: {themeType = themeDict[type]!.0
                usingArray = randomizeThis(themeArray[themeType])
                cardCount = usingArray.count
            }, label: {
                VStack{
                    Image(systemName: themeDict[type]!.1)
                    Text(type.capitalized).font(.callout)
                }.foregroundColor(themeDict[type]!.2)
            })
        }
        return thisButton
    }
    
    
    
    var body: some View {
        VStack{
            Text("Memorize!").foregroundColor(.yellow)
            
            ScrollView{
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))]) {
                    ForEach(0..<cardCount, id: \.self){ index in
                        CardView(content: usingArray[index]).aspectRatio(2/3, contentMode: .fit)
                    }
                }
                .foregroundColor(cardColor)
            }
            .padding(.horizontal)
            
            HStack{
                removeButton
                appendButton
                Spacer()
                themeButton("faces")
                themeButton("animals")
                themeButton("food")
            }
            .padding(.vertical)
        }
        .padding(.horizontal)
        .font(.largeTitle)
    }
}
 

struct CardView: View{
    
    let myRect = RoundedRectangle(cornerRadius: 20)
    var content: String
    @State var isFaceUp: Bool = false
    
    var body: some View{
        ZStack{
            if isFaceUp{
                myRect.fill().foregroundColor(.white)
                myRect.strokeBorder(lineWidth: 5)
                Text(content).font(.largeTitle)
            }
            else{
                myRect.fill()
                Text(" ").font(.largeTitle)
            }
        }
        .onTapGesture{isFaceUp = !isFaceUp}
        .font(.largeTitle)
    }
}
  



















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        memorizeView()
            .preferredColorScheme(.light)
            .previewInterfaceOrientation(.portrait)
        
        memorizeView()
            .preferredColorScheme(.dark)
        
    }
}
