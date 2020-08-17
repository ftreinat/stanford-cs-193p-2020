//
//  ThemeChooser.swift
//  Memorize
//
//  Created by Florian Treinat on 06.08.20.
//  Copyright © 2020 Florian Treinat. All rights reserved.
//

import Foundation
import Combine
import UIKit

class MemorizeThemeStore: ObservableObject {
    
    @Published var themes: [EmojiCardTheme] = [EmojiCardTheme]()
    
    let name: String
    
    var autosave: AnyCancellable?
    
    init(named name: String = "Memorize") {
        self.name = name
        let themeKey = "MemorizeThemes.\(name)"
        if let persitedThemesAsJson = UserDefaults.standard.object(forKey: themeKey) as? Data {
            if let memoryThemes = try? JSONDecoder().decode([EmojiCardTheme].self, from: persitedThemesAsJson) {
                self.themes = memoryThemes
            }
        }
        
        if themes.isEmpty {
            themes = EmojiThemeFactory.themes
        }
        
        autosave = $themes.sink { themes in
            let json = try? JSONEncoder().encode(themes)
            print("Theme: \(json?.utf8 ?? "nil")")
            UserDefaults.standard.set(json, forKey: themeKey)
        }
    }

    // MARK: Intents

    var colorPalette: [UIColor] {
        EmojiThemeFactory.getRandomColors()
    }
    
    func changeColor(of theme: EmojiCardTheme, to color: UIColor) {
        if let indexOfTheme = themes.firstIndex(matching: theme) {
            themes[indexOfTheme].color = color
        }
    }
    
    func isEmojiRemovalAllowed(for theme: EmojiCardTheme) -> Bool {
        theme.emojis.count > 2
    }
    
    func incrementNumberOfPairs(of theme: EmojiCardTheme) {
        if let indexOfTheme = themes.firstIndex(matching: theme) {
            themes[indexOfTheme].numberOfPairs += 1
        }
    }
    
    func decrementNumberOfPairs(of theme: EmojiCardTheme) {
        if let indexOfTheme = themes.firstIndex(matching: theme) {
            themes[indexOfTheme].numberOfPairs -= 1
        }
    }
    
    func changeName(of theme: EmojiCardTheme, to name: String) {
        if let indexOfTheme = themes.firstIndex(matching: theme) {
            themes[indexOfTheme].name = name
        }
    }
    
    func addEmoji(_ emoji: String, to theme: EmojiCardTheme) {
        if let indexOfTheme = themes.firstIndex(matching: theme), emoji.count == 1 {
            themes[indexOfTheme].emojis.append(emoji)
        }
    }
    
    func removeEmoji(_ emoji: String, from theme: EmojiCardTheme) {
        if let indexOfTheme = themes.firstIndex(matching: theme) {
            if let emojiIndex = themes[indexOfTheme].emojis.firstIndex(of: emoji) {
                themes[indexOfTheme].emojis.remove(at: emojiIndex)
            }
        }
    }
    
    func deleteTheme(_ theme: EmojiCardTheme) {
        if let indexOfTheme = themes.firstIndex(matching: theme) {
            themes.remove(at: indexOfTheme)
        }
    }
    
    func addNewTheme() {
        themes.append(EmojiThemeFactory.getRandomTheme())
    }
    
}

extension Data {
    // just a simple converter from a Data to a String
    var utf8: String? { String(data: self, encoding: .utf8 ) }
}



