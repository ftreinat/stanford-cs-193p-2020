//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Florian Treinat on 09.06.20.
//  Copyright © 2020 Florian Treinat. All rights reserved.
//

import Foundation
import UIKit

class EmojiMemoryGame: ObservableObject {
    @Published private(set) var game = createMemoryGame()
    
    private static let themes: [EmojiCardTheme] = [
        EmojiCardTheme(name: "Food", emojis: ["🥜", "🥥", "🌯", "🥑", "🍌","🌽","🥞","🍕","🍝"], color: UIColor.green.rgb, numberOfCards: 9),
        EmojiCardTheme(name: "Animals", emojis: ["🐌", "🦖", "🦆", "🐝", "🦋","🦄","🐳","🐘","🦚","🦦","🐿"], color: UIColor.blue.rgb, numberOfCards: 11),
        EmojiCardTheme(name: "Sports", emojis: ["⚽️", "🏓", "🏀", "🏈", "🤾🏻‍♀️", "🏌🏻‍♂️", "🥋", "🏹","🥊","🎾","🧗🏻","🚴🏻‍♂️"], color: UIColor.red.rgb, numberOfCards: 12),
        EmojiCardTheme(name: "Halloween", emojis: ["🎃", "🕷", "🍎", "🍭", "👻", "🧙🏼‍♀️"], color: UIColor.orange.rgb, numberOfCards: 6)
    ]

    private static var theme = chooseRandomEmojiTheme()
    
    private static func createMemoryGame() -> MemoryGame<String> {
        EmojiMemoryGame.theme = chooseRandomEmojiTheme()
        return MemoryGame<String>(numberOfPairsOfCards: EmojiMemoryGame.theme.numberOfCards) { pairIndex in
            return EmojiMemoryGame.theme.emojis[pairIndex]
        }
    }
    
    // MARK: - Access to the Model
    var cards: Array<MemoryGame<String>.Card> {
        return game.cards
    }
    
    var themecolor: UIColor {
        return EmojiMemoryGame.theme.color
    }
    
    var themename: String {
        return EmojiMemoryGame.theme.name
    }
    
    var points: Int {
        return game.score
    }
    
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        objectWillChange.send()
        game.choose(card: card)
    }
    
    func startNewGame() {
        game = EmojiMemoryGame.createMemoryGame()
    }
    
    static func chooseRandomEmojiTheme() -> EmojiCardTheme {
        return EmojiMemoryGame.themes.randomElement()!
    }
    
}

struct EmojiCardTheme : Codable {
    
    internal init(name: String, emojis: [String], color themeColorAsRGB: UIColor.RGB, numberOfCards: Int) {
        self.name = name
        self.emojis = emojis
        self.numberOfCards = numberOfCards
        self.themeColorAsRGB = themeColorAsRGB
    }
    
    let name: String
    let emojis: [String]
    let numberOfCards: Int
    private let themeColorAsRGB: UIColor.RGB

    var color: UIColor {
        UIColor(themeColorAsRGB)
    }
    
}
