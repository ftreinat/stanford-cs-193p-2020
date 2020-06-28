//
//  SetGame.swift
//  Set
//
//  Created by Florian Treinat on 21.06.20.
//  Copyright © 2020 Florian Treinat. All rights reserved.
//

import Foundation


struct SetGame<Type, Number, Shading, Color> where
    Type: CaseIterable, Type: Hashable,
    Number: CaseIterable, Number: Hashable,
    Shading: CaseIterable, Shading: Hashable,
    Color: CaseIterable, Color:  Hashable {
    
    typealias SetCard = Card<Type, Number, Shading, Color>
    var carddeck: [SetCard]
    var openCards: [SetCard]
    let numberOfPlayingCards = 12
    
    var numberOfSelectedCards : Int {
        print("werde berechnet")
        return openCards.filter {
            $0.isSelected
        }.count
    }
    
    init() {
        carddeck = [SetCard]()
        openCards = [SetCard]()
        
        for type in Type.allCases {
            for number in Number.allCases {
                for shade in Shading.allCases {
                    for color in Color.allCases {
                        carddeck.append(SetCard(type: type, number: number, shade: shade, color: color))
                    }
                }
            }
        }
        carddeck.shuffle()
        openCards.append(contentsOf: carddeck[0..<numberOfPlayingCards])
    }
    
    var areSelectedCardsASet: Bool {
        // hier drin alle selektierten Karten auf isMatched prüfen
        openCards.filter({ $0.isSelected }).map({ $0.isMatched })
        
        
        return false
    }
        
    mutating func select(card: SetCard) {
        if let indexOfCard = openCards.firstIndex(matching: card) {
            
            if numberOfSelectedCards == 3 {
                // es waren zuvor 3 selektiert
                let indicesOfSelectedCards = openCards.indices.filter { (index) in  openCards[index].isSelected }
                let indexOfFirstCard = indicesOfSelectedCards[0]
                let indexOfSecondCard = indicesOfSelectedCards[1]
                let indexOfThirdCard = indicesOfSelectedCards[2]
                var firstCard = openCards[indexOfFirstCard]
                var secondCard = openCards[indexOfSecondCard]
                var thirdCard = openCards[indexOfThirdCard]

                firstCard.isSelected = false
                secondCard.isSelected = false
                thirdCard.isSelected = false
                
                if firstCard.isMatched! && secondCard.isMatched! && thirdCard.isMatched! {
                    //neue Karten
                    for card in [firstCard, secondCard, thirdCard] {
                        if let indexOfCardToRemove = openCards.firstIndex(matching: card) {
                            openCards.remove(at: indexOfCardToRemove)
                            
                            if !carddeck.isEmpty {
                                let newCard = carddeck.first!
                                carddeck.remove(at: 0)
                            }
                        }
                    }
                    
                    
                    
                } else {
                    firstCard.isMatched = nil
                    secondCard.isMatched = nil
                    thirdCard.isMatched = nil
                }
                
                
                
            }
            
            // 1: < 3 selektiert -> Selektiere Karte
                // 1.1 sind nun 3 selektiert? - Prüfe auf Set
                // 1.2 sind weiterhin < 3 selektiert -> mache nix
            // 2: 3 Selektiert:
                // 2.1 : Karte aus Set selektiert
                // 2.2 : Karte außerhalb Set selektiert
            
            openCards[indexOfCard].isSelected.toggle()
                        
            if numberOfSelectedCards == 3 {
                // Wir haben 3 Karten: Auf Set testen
                let indicesOfSelectedCards = openCards.indices.filter { (index) in  openCards[index].isSelected }
                
                let indexOfFirstCard = indicesOfSelectedCards[0]
                let indexOfSecondCard = indicesOfSelectedCards[1]
                let indexOfThirdCard = indicesOfSelectedCards[2]
                let firstCard = openCards[indexOfFirstCard]
                let secondCard = openCards[indexOfSecondCard]
                let thirdCard = openCards[indexOfThirdCard]
                
                if attributesAreASet(first: firstCard.type , second: secondCard.type, third: thirdCard.type) &&
                   attributesAreASet(first: firstCard.number , second: secondCard.number, third: thirdCard.number) &&
                   attributesAreASet(first: firstCard.color , second: secondCard.color, third: thirdCard.color) &&
                    attributesAreASet(first: firstCard.shade , second: secondCard.shade, third: thirdCard.shade) {
                    
                    // Found a Match
                    openCards[indexOfFirstCard].isMatched = true
                    openCards[indexOfSecondCard].isMatched = true
                    openCards[indexOfThirdCard].isMatched = true
                    
                } else {
                    openCards[indexOfFirstCard].isMatched = false
                    openCards[indexOfSecondCard].isMatched = false
                    openCards[indexOfThirdCard].isMatched = false
                }
            }
            
        }
    }
    
    func attributesAreASet<T>(first: T, second: T, third: T) -> Bool where T : Equatable  {
        return first == second && second == third
            || first != second && second != third && first != third
    }
    
    struct Card<Type, Number, Shading, Color>: Identifiable {
        
        var id = UUID.init()
        
        var isSelected: Bool = false
        var isMatched: Bool?
        
        var type: Type
        var number: Number
        var shade: Shading
        var color: Color
    }

}


