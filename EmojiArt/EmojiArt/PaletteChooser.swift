//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Florian Treinat on 04.08.20.
//  Copyright © 2020 Florian Treinat. All rights reserved.
//

import SwiftUI

struct PaletteChooser: View {
    @ObservedObject var document: EmojiArtDocument
    
    @Binding var chosenPalette: String
    
    var body: some View {
        HStack {
            Stepper(onIncrement: {
                self.chosenPalette = self.document.palette(after: self.chosenPalette)
            }, onDecrement: {
                self.chosenPalette = self.document.palette(before: self.chosenPalette)
            }, label: {
                EmptyView()
            })
            Text(self.document.paletteNames[self.chosenPalette] ?? "")
        }
        .fixedSize(horizontal: true, vertical: false)
        .onAppear { self.chosenPalette = self.document.defaultPalette }
    }
}

struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        let emojiArt = EmojiArtDocument()
        return PaletteChooser(document: emojiArt, chosenPalette: Binding.constant(""))
    }
}
