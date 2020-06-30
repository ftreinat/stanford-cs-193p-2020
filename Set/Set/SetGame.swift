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
    private(set) var carddeck: [SetCard]
    private(set) var cardsOnField: [SetCard]
    var cheat: Bool = false 
    private let numberOfPlayingCards = 12
    
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
        for index in 0..<numberOfPlayingCards {
            cardsOnField.insert(carddeck.remove(at: index), at: index)
        }
    }
    
    var selectedCardsAreASet: Bool {
        cardsOnField.filter({ $0.isSelected }).filter({ $0.matchState == SetCard.MatchState.match }).count == 3
    }
        
    mutating func select(card: SetCard) {
        if let indexOfCard = cardsOnField.firstIndex(matching: card) {
            
            // wenn zu Beginn 3 Karten selektiert waren -> 4. selektiert
            if numberOfSelectedCards == 3 {
                cleanUpSet()
            }
                
            // select the card
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
                
                if cardsAreASet(first: firstCard, second: secondCard, third: thirdCard) {
                    // Found a Match
                    cardsOnField[indexOfFirstCard].matchState = .match
                    cardsOnField[indexOfSecondCard].matchState = .match
                    cardsOnField[indexOfThirdCard].matchState = .match
                    
                } else {
                    // A Mismatch
                    cardsOnField[indexOfFirstCard].matchState = .mismatch
                    cardsOnField[indexOfSecondCard].matchState = .mismatch
                    cardsOnField[indexOfThirdCard].matchState = .mismatch
                }
            }
            
        }
    }
    
    private mutating func cleanUpSet() {
        let indicesOfSelectedCards = cardsOnField.indices.filter { (index) in  cardsOnField[index].isSelected }
        let indexOfFirstCard = indicesOfSelectedCards[0]
        let indexOfSecondCard = indicesOfSelectedCards[1]
        let indexOfThirdCard = indicesOfSelectedCards[2]

        if selectedCardsAreASet {
        //neue Karten
            for cardindex in [indexOfFirstCard, indexOfSecondCard, indexOfThirdCard] {
                if !carddeck.isEmpty {
                    cardsOnField[cardindex] = carddeck.remove(at: 0)
                    print("Neue Card")
                } else {
                    cardsOnField.remove(at: cardindex)
                }
           }
        } else {
            cardsOnField[indexOfFirstCard].isSelected = false
            cardsOnField[indexOfSecondCard].isSelected = false
            cardsOnField[indexOfThirdCard].isSelected = false
            
            cardsOnField[indexOfFirstCard].matchState = .none
            cardsOnField[indexOfSecondCard].matchState = .none
            cardsOnField[indexOfThirdCard].matchState = .none
            print("Falsches set reseted")
        }
    }
    
    private func cardsAreASet(first: SetCard, second: SetCard, third: SetCard) -> Bool {
        return self.cheat || attributesAreASet(first: first.type , second: second.type, third: third.type) &&
        attributesAreASet(first: first.number , second: second.number, third: third.number) &&
        attributesAreASet(first: first.color , second: second.color, third: third.color) &&
        attributesAreASet(first: first.shade , second: second.shade, third: third.shade)
    }
    
    private func attributesAreASet<T>(first: T, second: T, third: T) -> Bool where T : Equatable  {
        return first == second && second == third
            || first != second && second != third && first != third
    }
    
    mutating func drawCards() {
        if !carddeck.isEmpty {
            if numberOfSelectedCards == 3 && selectedCardsAreASet {
                cleanUpSet()
            } else {
                for _ in 1...3 {
                    cardsOnField.append(carddeck.remove(at: 0))
                }
            }
        }
    }
    
    struct Card<Type, Number, Shading, Color>: Identifiable {
        
        var id = UUID.init()
        
        var isSelected: Bool = false
        var matchState: MatchState = .none
        
        var type: Type
        var number: Number
        var shade: Shading
        var color: Color
        
        var isPartOfAMatch: Bool {
            matchState == .match
        }
        
        var isPartOfAMismatch: Bool {
            matchState == .mismatch
        }
        
        enum MatchState {
            case match
            case mismatch
            case none
        }
    }

}


