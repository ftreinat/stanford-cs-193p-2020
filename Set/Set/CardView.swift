//
//  CardView.swift
//  Set
//
//  Created by Florian Treinat on 23.06.20.
//  Copyright © 2020 Florian Treinat. All rights reserved.
//

import SwiftUI

struct CardView: View {
    var card: SetGameCard
        
    var body: some View {
        VStack {
            ForEach(0..<extractAmount(from: card.number)) { _ in
                self.body(for: self.card)
            }
        }
            .cardify(isFaceUp: true)
            .padding(4)
            .foregroundColor(determineBorderColorFor(card))

            //.aspectRatio(3/2, contentMode: .fit)
    }
        
    func body(for card: SetGameCard) -> some View {
        Group {
            if card.type == ShapeSetGame.Shape.diamond {
                if card.shade == ShapeSetGame.Shading.empty {
                    Diamond().stroke(lineWidth: strokeLineWidth)
                } else {
                    Diamond()
                }
            } else if card.type == ShapeSetGame.Shape.circle {
                if card.shade == ShapeSetGame.Shading.empty {
                    Circle()
                        .stroke(lineWidth: strokeLineWidth)
                } else {
                    Circle()
                }
            } else if card.type == ShapeSetGame.Shape.squiggle {
                if card.shade == ShapeSetGame.Shading.empty {
                    Capsule()
                        .stroke(lineWidth: strokeLineWidth)
                } else {
                    Capsule()
                }
            }
        }
        .foregroundColor(extractColor(from: card.color))
        .opacity(card.shade == ShapeSetGame.Shading.stroked ? opacityValueForStroked : 1)
        .padding()
    }
    
    func determineBorderColorFor(_ card: SetGameCard) -> Color {
        if card.isPartOfAMatch {
            return Color.green
        } else if card.isPartOfAMismatch {
            return Color.red
        } else if card.isSelected {
            return Color.yellow
        } else {
            return Color.black
        }
    }
    
    func extractColor(from color: ShapeSetGame.Color) -> Color {
        switch (color) {
        case .blue:
            return Color.blue
        case .green:
            return Color.green
        case .red:
            return Color.red
        }
    }
    
    func extractAmount(from number: ShapeSetGame.Number) -> Int {
        switch number {
        case .one:
            return 1
        case .two:
            return 2
        case .three:
            return 3
        }
    }
    
}

// MARK: Drawing Constants

let strokeLineWidth: CGFloat = 2.0
let opacityValueForStroked: Double = 0.2

struct CardView_Previews: PreviewProvider {
    
    static var previews: some View {
        Text("Fix Me")
    }
}
