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
    var carddeck: [SetCard] {
        didSet {
            print("Wuride geändert")
            drawNewDeck = true
        }
    }
    var cardsOnField: [SetCard]
    let numberOfPlayingCards = 15
    
    var numberOfSelectedCards : Int {
        return cardsOnField.filter {
            $0.isSelected
        }.count
    }
    
    var drawNewDeck = false
    
    init() {
        carddeck = [SetCard]()
        cardsOnField = [SetCard]()
        
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
        drawInitialCards()
        //cardsOnField.append(contentsOf: carddeck[0..<numberOfPlayingCards])
    }
    
    mutating func drawInitialCards() {
        for index in 0..<numberOfPlayingCards {
            cardsOnField.insert(carddeck.remove(at: index), at: index)
        }
    }
    
    var selectedCardsAreASet: Bool {
        // hier drin alle selektierten Karten auf isMatched prüfen
        let selectedCards = cardsOnField.filter({ $0.isSelected })
        
        if selectedCards.count != 3 {
            return false
        } else {
            return selectedCards.map({ $0.isMatched }).reduce(true, { (result: Bool,current: Bool?) in
            result && (current ?? false) })
        }
    }
        
    mutating func select(card: SetCard) {
        if let indexOfCard = cardsOnField.firstIndex(matching: card) {
            
            if numberOfSelectedCards == 3 {
                
                let indicesOfSelectedCards = cardsOnField.indices.filter { (index) in  cardsOnField[index].isSelected }
                let indexOfFirstCard = indicesOfSelectedCards[0]
                let indexOfSecondCard = indicesOfSelectedCards[1]
                let indexOfThirdCard = indicesOfSelectedCards[2]

                if selectedCardsAreASet {
                    cardsOnField[indexOfFirstCard].isSelected = false
                           cardsOnField[indexOfSecondCard].isSelected = false
                           cardsOnField[indexOfThirdCard].isSelected = false
                    
                //neue Karten
                    for cardindex in [indexOfFirstCard, indexOfSecondCard, indexOfThirdCard] {
                        if !carddeck.isEmpty {
                            let newCard = carddeck.remove(at: 0)
                            cardsOnField.insert(newCard, at: cardindex)
                            print("Neue Card")
                        } else {
                            cardsOnField.remove(at: cardindex)
                        }
                   }
                } else {
                    cardsOnField[indexOfFirstCard].isSelected = false
                           cardsOnField[indexOfSecondCard].isSelected = false
                           cardsOnField[indexOfThirdCard].isSelected = false
                    
                    print("Falsches set reseted")
                    cardsOnField[indexOfFirstCard].isMatched = nil
                    cardsOnField[indexOfSecondCard].isMatched = nil
                    cardsOnField[indexOfThirdCard].isMatched = nil
                }
                
            } else {
                //keiner oder bis zu 2 selektierte Karten
            }
                
            // 1: < 3 selektiert -> Selektiere Karte
                // 1.1 sind nun 3 selektiert? - Prüfe auf Set
                // 1.2 sind weiterhin < 3 selektiert -> mache nix
            // 2: 3 Selektiert:
                // 2.1 : Karte aus Set selektiert
                // 2.2 : Karte außerhalb Set selektiert
            
            cardsOnField[indexOfCard].isSelected.toggle()
                        
            if numberOfSelectedCards == 3 {
                // Wir haben 3 Karten: Auf Set testen
                let indicesOfSelectedCards = cardsOnField.indices.filter { (index) in  cardsOnField[index].isSelected }
                
                let indexOfFirstCard = indicesOfSelectedCards[0]
                let indexOfSecondCard = indicesOfSelectedCards[1]
                let indexOfThirdCard = indicesOfSelectedCards[2]
                let firstCard = cardsOnField[indexOfFirstCard]
                let secondCard = cardsOnField[indexOfSecondCard]
                let thirdCard = cardsOnField[indexOfThirdCard]
                
                if attributesAreASet(first: firstCard.type , second: secondCard.type, third: thirdCard.type) &&
                   attributesAreASet(first: firstCard.number , second: secondCard.number, third: thirdCard.number) &&
                   attributesAreASet(first: firstCard.color , second: secondCard.color, third: thirdCard.color) &&
                    attributesAreASet(first: firstCard.shade , second: secondCard.shade, third: thirdCard.shade) {
                    
                    // Found a Match
                    cardsOnField[indexOfFirstCard].isMatched = true
                    cardsOnField[indexOfSecondCard].isMatched = true
                    cardsOnField[indexOfThirdCard].isMatched = true
                    
                } else {
                    cardsOnField[indexOfFirstCard].isMatched = false
                    cardsOnField[indexOfSecondCard].isMatched = false
                    cardsOnField[indexOfThirdCard].isMatched = false
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
        var isMatched: Bool? = nil
        
        var type: Type
        var number: Number
        var shade: Shading
        var color: Color
        
        enum MatchState {
            case matched
            case mismatch
            case unmatched
        }
    }

}


