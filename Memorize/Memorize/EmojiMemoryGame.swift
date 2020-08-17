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
    @Published private(set) var game: MemoryGame<String>
    
    var theme: EmojiCardTheme
    
    init(theme: EmojiCardTheme) {
        self.theme = theme
        self.game = EmojiMemoryGame.createMemoryGame(for: theme)
    }
    
    private static func createMemoryGame(for theme: EmojiCardTheme) -> MemoryGame<String> {
        return MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairs) { pairIndex in
            return theme.emojis[pairIndex]
        }
    }
    
    // MARK: - Access to the Model
    var cards: Array<MemoryGame<String>.Card> {
        return game.cards
    }
    
    var themecolor: UIColor {
        return theme.color
    }
    
    var themename: String {
        return theme.name
    }
    
    var themeAsJSON: String {
        return theme.json ?? "Kein Theme vorhanden"
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
        game = EmojiMemoryGame.createMemoryGame(for: theme)
        print(theme.json ?? "Kein Theme vorhanden")
    }
    
    static func chooseRandomEmojiTheme() -> EmojiCardTheme {
        return EmojiThemeFactory.getRandomTheme()
    }
    
}

struct EmojiCardTheme : Codable, Identifiable {
    
    internal init(name: String, emojis: [String], color themeColorAsRGB: UIColor.RGB, numberOfCards: Int) {
        self.name = name
        self._emojis = emojis
        self._numberOfPairs = numberOfCards
        self.themeColorAsRGB = themeColorAsRGB
    }
        
    let id = UUID()
    var name: String
    private var _emojis: [String]
    var emojis: [String] {
        get {
            _emojis
        }
        set {
            if newValue.count > 1 {
                _emojis = newValue
            }
        }
    }
    private var _numberOfPairs: Int
    var numberOfPairs: Int
    {
        get {
            _numberOfPairs > emojis.count ? emojis.count : _numberOfPairs
        }
        set(newValue) {
            if newValue <= emojis.count, newValue > 1 {
                _numberOfPairs = newValue
            }
        }
    }
    
    private var themeColorAsRGB: UIColor.RGB

    var color: UIColor {
        get {
            UIColor(themeColorAsRGB)
        }
        set {
            themeColorAsRGB = newValue.rgb
        }
    }
    
    var json: String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let json = try? encoder.encode(self)
        if let jsonData = json {
           return String(data: jsonData, encoding: .utf8)
        } else {
            return nil
        }
    }
    
}
