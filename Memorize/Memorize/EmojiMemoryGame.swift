//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Florian Treinat on 09.06.20.
//  Copyright © 2020 Florian Treinat. All rights reserved.
//

import Foundation

class EmojiMemoryGame: ObservableObject {
    @Published private(set) var game = createMemoryGame()
    
    static let themes: [EmojiTheme] = [
        EmojiTheme(name: "Food", emojis: ["🥜", "🥥", "🌯", "🥑", "🍌"], color: .green),
        EmojiTheme(name: "Animals", emojis: ["🐌", "🦖", "🦆", "🐝", "🦋"], color: .blue),
        EmojiTheme(name: "Sports", emojis: ["⚽️", "🏓", "🏀", "🏈", "🤾🏻‍♀️", "🏌🏻‍♂️", "🥋", "🏹"], color: .red),
        EmojiTheme(name: "Halloween", emojis: ["🎃", "🕷", "🍎", "🍭", "👻" ], color: .orange)
    ]

    static var theme = chooseRandomEmojiTheme()
    
    static func createMemoryGame() -> MemoryGame<String> {
        EmojiMemoryGame.theme = chooseRandomEmojiTheme()
        return MemoryGame<String>(numberOfPairsOfCards: EmojiMemoryGame.theme.emojis.count) { pairIndex in
            return EmojiMemoryGame.theme.emojis[pairIndex]
        }
    }
    
    // MARK: - Access to the Model
    var cards: Array<MemoryGame<String>.Card> {
        return game.cards
    }
    
    var themecolor: ThemeColor {
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
    
    static func chooseRandomEmojiTheme() -> EmojiTheme {
        return EmojiMemoryGame.themes.randomElement()!
    }
    
}

struct EmojiTheme {
    var name: String
    var emojis: [String]
    var color: ThemeColor
}

enum ThemeColor {
    case green, red, blue, orange
}
