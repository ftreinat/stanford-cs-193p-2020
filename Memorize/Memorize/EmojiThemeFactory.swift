//
//  EmojiThemeFactory.swift
//  Memorize
//
//  Created by Florian Treinat on 15.08.20.
//  Copyright © 2020 Florian Treinat. All rights reserved.
//

import Foundation
import UIKit

struct EmojiThemeFactory {
 
    public static let themes: [EmojiCardTheme] = [
        EmojiCardTheme(name: "Food", emojis: ["🥜", "🥥", "🌯", "🥑", "🍌","🌽","🥞","🍕","🍝"], color: UIColor.green.rgb, numberOfCards: 9),
        EmojiCardTheme(name: "Animals", emojis: ["🐌", "🦖", "🦆", "🐝", "🦋","🦄","🐳","🐘","🦚","🦦","🐿"], color: UIColor.blue.rgb, numberOfCards: 11),
        EmojiCardTheme(name: "Sports", emojis: ["⚽️", "🏓", "🏀", "🏈", "🤾🏻‍♀️", "🏌🏻‍♂️", "🥋", "🏹","🥊","🎾","🧗🏻","🚴🏻‍♂️"], color: UIColor.red.rgb, numberOfCards: 12),
        EmojiCardTheme(name: "Halloweeeeeeeeen", emojis: ["🎃", "🕷", "🍎", "🍭", "👻", "🧙🏼‍♀️"], color: UIColor.orange.rgb, numberOfCards: 6)
    ]
    
    public static func getRandomTheme() -> EmojiCardTheme {
        themes.randomElement()!
    }
    
    public static func getRandomColors() -> [UIColor] {
        [UIColor.green, UIColor.magenta, UIColor.blue, UIColor.red, UIColor.yellow, UIColor.orange, UIColor.purple, UIColor.brown, UIColor.cyan]
    }
}
