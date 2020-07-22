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
        GeometryReader { geometry in
            self.body(for: self.card, in: geometry.size)
        }
    }
    
    func body(for card: SetGameCard, in size: CGSize) -> some View {
         VStack {
                ForEach(0..<extractAmount(from: card.number)) { _ in
                    self.shape(for: self.card)
                    .aspectRatio(3/2, contentMode: .fit)
                }
            }
                .cardify(isFaceUp: true)
                .foregroundColor(determineBorderColorFor(card))
                .aspectRatio(cardAspectRatio, contentMode: .fit)
                .padding(.top, outsideCardPadding)
                .padding(.bottom, outsideCardPadding)
                .rotation3DEffect(Angle.degrees(card.isSelected ? selectionDegree : 0), axis: (x: 1, y: 0, z: 1))
    //        .rotation3DEffect(Angle.degrees(card.isPartOfAMatch || card.isPartOfAMismatch ? 0 : 360), axis: (x: 0, y: 1, z: 0))
                .animation(.linear(duration: 0.35))
    //            .transition(AnyTransition.offset(CGSize(width: -200, height: -100)))
    //            .scaleEffect(getscale(for: card))
    }
        
    func shape(for card: SetGameCard) -> some View {
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
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: strokeLineWidth)
                } else {
                    RoundedRectangle(cornerRadius: 5)
                }
            }
        }
        .foregroundColor(extractColor(from: card.color))
        .opacity(card.shade == ShapeSetGame.Shading.stroked ? opacityValueForStroked : 1)
        .aspectRatio(shapeAspectRatio, contentMode: .fit)
        .padding(insideCardPadding)
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
    
    func getRandomPointOutsideField() {
        
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
    
    func getscale(for card: SetGameCard) -> CGFloat {
        if card.isPartOfAMatch {
            return 1.05
        } else if card.isPartOfAMismatch {
            return 0.8
        } else {
            return 1
        }
    }
    
}

// MARK: Drawing Constants

let strokeLineWidth: CGFloat = 2.0
let opacityValueForStroked: Double = 0.2
let shapeAspectRatio: CGFloat = 3/2
let cardAspectRatio: CGFloat = 2/3
let insideCardPadding: CGFloat = 4.0
let outsideCardPadding: CGFloat = 2.0

let selectionDegree = 7.0

struct CardView_Previews: PreviewProvider {
    
    static var previews: some View {
        Text("Fix Me")
    }
}
