//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Florian Treinat on 23.07.20.
//  Copyright © 2020 Florian Treinat. All rights reserved.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    
    @ObservedObject var document: EmojiArtDocument
    
    var body: some View {
//        \.self ist ein Keypath und gibt ein Attribut eines Objektes an. Hier self
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(EmojiArtDocument.palette.map { String($0) }, id: \.self) { emoji in
                        Text(emoji)
                            .font(Font.system(size: self.defaultEmojiSize))
                    }
                }
            }
            .padding(.horizontal)
            
            Color.white
            .overlay(getBackgroundImageWithCompatability())
// Klappt leider beim alten XCode nicht -> iOS Target 13.2 unter Mojave. Umweg mittels func getBackgroundImageAsView
//                .overlay(
//                    Group {
//                        if self.document.backgroundImage != nil {
//                            Image(self.document.backgroundImage!)
//                        }
//                    }
//            )
                .edgesIgnoringSafeArea([.horizontal, .bottom])
        }
    }
    
    @ViewBuilder
    func getBackgroundImageWithCompatability() -> some View {
        // Annotation ViewBuilder bewirkt, dass im else Fall kein EmptyView angegeben werden muss
        if document.backgroundImage != nil {
            return Image(uiImage: document.backgroundImage!)
        }
    }
    
    private let defaultEmojiSize: CGFloat = 40
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        var document = EmojiArtDocument()
        return EmojiArtDocumentView(document: document)
    }
}
