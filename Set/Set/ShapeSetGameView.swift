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
        Grid(items: shapeSetGame.cards) { card in
            CardView(card: card)
                .onTapGesture {
                    self.shapeSetGame.select(card: card)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ShapeSetGameView()
    }
}
