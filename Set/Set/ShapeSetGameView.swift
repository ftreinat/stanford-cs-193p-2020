//
//  ShapeSetGameView.swift
//  Set
//
//  Created by Florian Treinat on 21.06.20.
//  Copyright © 2020 Florian Treinat. All rights reserved.
//

import SwiftUI

struct ShapeSetGameView: View {
    @ObservedObject var shapeSetGame = ShapeSetGame()
    
    var body: some View {
        VStack {
            Grid(items: shapeSetGame.cards) { card in
                CardView(card: card)
                    .onTapGesture {
                        self.shapeSetGame.select(card: card)
                }
            }
            .padding()
            self.bottomRow()
                .padding(.top, 3)
        }
    }
    
    func bottomRow() -> some View {
        HStack {
            Spacer()
            Text("Cheat")
                .onTapGesture { self.shapeSetGame.cheat.toggle() }
                .font(self.shapeSetGame.cheat ? Font.body.bold() : Font.body)
            Spacer()
            Button("Draw Cards") {
                self.shapeSetGame.drawCards()
            }
                .disabled(self.shapeSetGame.isDeckEmpty)
            Spacer()
            Button("Reset") {
                self.shapeSetGame.reset()
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ShapeSetGameView()
    }
}
