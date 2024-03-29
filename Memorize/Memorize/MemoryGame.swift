//
//  MemoryGame.swift
//  Memorize
//
//  Created by Florian Treinat on 09.06.20.
//  Copyright © 2020 Florian Treinat. All rights reserved.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    private(set) var score = 0
    private var alreadySeenCards: Set<Int> = Set()
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
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
        
        for pairIndex in 0..<numberOfPairsOfCards {
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
    
    private func calculatePointsForMismatch(firstCardIndex first: Int, secondCardIndex second: Int) -> Int {
        var penalty = alreadySeenCards.contains(first) ? GamePoints.mismatch.rawValue : 0
        penalty += alreadySeenCards.contains(second) ? GamePoints.mismatch.rawValue : 0
        return penalty
    }
    
    private enum GamePoints: Int {
        case match = 2,
             mismatch = -1
    }
    
    struct Card: Identifiable {
        var id: Int
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        
        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        
        var content: CardContent
        
        // MARK: - Bonus Time
        
        //this could give matching bonus points
        //if the user matches the card
        //before a certain amount of time passes during which the card is face up
        
        //can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        
        //how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        //the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        //the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currenty so)
        var pastFaceUpTime: TimeInterval = 0
        
        //how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        //percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
        }
        //whether the card was matched during the bonus time persiod
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        //whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        //called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        //called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    
    }
}
