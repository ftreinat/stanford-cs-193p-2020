//
//  ShapeSetGame.swift
//  Set
//
//  Created by Florian Treinat on 22.06.20.
//  Copyright © 2020 Florian Treinat. All rights reserved.
//

import Foundation

typealias SetGameWithShapes = SetGame<ShapeSetGame.Shape,ShapeSetGame.Number,ShapeSetGame.Shading,ShapeSetGame.Color>
typealias SetGameCard = SetGame<ShapeSetGame.Shape,ShapeSetGame.Number,ShapeSetGame.Shading,ShapeSetGame.Color>.Card<ShapeSetGame.Shape,ShapeSetGame.Number,ShapeSetGame.Shading,ShapeSetGame.Color>

class ShapeSetGame : ObservableObject {
    @Published private(set) var game = createSetGame()
    
    static func createSetGame() -> SetGameWithShapes {
        SetGame<Shape, Number, Shading, Color>()
    }
    
    var cards: [SetGameWithShapes.SetCard] {
        game.cardsOnField
    }
    
    func select(card: SetGameCard) {
        objectWillChange.send()
        game.select(card: card)
    }
    
    enum Color: CaseIterable {
        case green
        case red
        case blue
    }
    
    enum Shape: CaseIterable {
        case circle
        case diamond
        case squiggle
    }
    
    enum Shading: CaseIterable {
        case filled
        case stroked
        case empty
    }
    
    enum Number: CaseIterable {
        case one
        case two
        case three
    }
}
