//
//  MemoryGame.swift
//  Memorize
//
//  Created by Florian Treinat on 09.06.20.
//  Copyright © 2020 Florian Treinat. All rights reserved.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    var cards: Array<Card>
    var score = 0
    var alreadySeenCards: Set<Int> = Set()
    
    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.only }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array()
        var randomizer = SystemRandomNumberGenerator()
        
        let numberOfPairsOfCardsShuffeld = Int.random(in: 3..<numberOfPairsOfCards, using: &randomizer)
        for pairIndex in 0..<numberOfPairsOfCardsShuffeld {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(id: pairIndex*2, content: content))
            cards.append(Card(id: pairIndex*2+1, content: content))
        }
        
        cards.shuffle(using: &randomizer)
    }
    
    //mutating keyword because of changing the card inside our cards Array
    mutating func choose(card: Card) {
        if let chosenIndex: Int = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
 
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += GamePoints.match.rawValue
                } else {
                    //mismatch
                    score += calculatePointsForMismatch(firstCardIndex: chosenIndex, secondCardIndex: potentialMatchIndex)
                    alreadySeenCards.insert(chosenIndex)
                    alreadySeenCards.insert(potentialMatchIndex)
                }
                
                cards[chosenIndex].isFaceUp = true
                
            } else {
//          Umdrehen der Karten wird von der computed Property erledigt
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
    func calculatePointsForMismatch(firstCardIndex first: Int, secondCardIndex second: Int) -> Int {
        var penalty = alreadySeenCards.contains(first) ? GamePoints.mismatch.rawValue : 0
        penalty += alreadySeenCards.contains(second) ? GamePoints.mismatch.rawValue : 0
        return penalty
    }
    
    enum GamePoints: Int {
        case match = 2,
             mismatch = -1
    }
    
    struct Card: Identifiable {
        var id: Int
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
    }
}
