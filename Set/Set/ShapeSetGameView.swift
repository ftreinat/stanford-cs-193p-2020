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
            self.cardGrid()
            self.bottomRow()
                .padding(.top, 3)
        }
    }
        
    func cardGrid() -> some View {
        GeometryReader { geometry in
            Grid(items: self.shapeSetGame.cards) { card in
                CardView(card: card)
                    .onTapGesture {
                        self.shapeSetGame.select(card: card)
                    }
                .transition(AnyTransition.offset(self.calculateRandomOffset(for: geometry.size)))
            }
            .onAppear {
                self.shapeSetGame.drawInitialCards()
            }
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
    
    func calculateRandomOffset(for size: CGSize) -> CGSize {
        //Vektorlänge berechnen
        let length = Double(sqrt(size.height*size.height + size.width*size.width))
        //Zufälliger Winkel
        let angle = Angle.degrees(Double.random(in: 0..<360))
        
        return CGSize(width: length*cos(angle.radians), height: length*sin(angle.radians))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ShapeSetGameView()
    }
}
