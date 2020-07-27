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
    
    var imageURL = "https://www.google.com/imgres?imgurl=https%3A%2F%2Fthumbs.dreamstime.com%2Fz%2Fcartoon-countryside-illustration-beautiful-summer-village-40763564.jpg&imgrefurl=https%3A%2F%2Fwww.dreamstime.com%2Fstock-images-cartoon-countryside-illustration-beautiful-summer-village-image40763564&tbnid=6BQkf8TaGSMQkM&vet=12ahUKEwj7vr7K7uXqAhUIgKQKHRMJC-4QMygFegUIARCsAQ..i&docid=uw1mAdqWrQWrnM&w=1300&h=944&q=countryside%20cartoon&client=safari&ved=2ahUKEwj7vr7K7uXqAhUIgKQKHRMJC-4QMygFegUIARCsAQ";
    
    var body: some View {
//        \.self ist ein Keypath und gibt ein Attribut eines Objektes an. Hier self
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(EmojiArtDocument.palette.map { String($0) }, id: \.self) { emoji in
                        Text(emoji)
                            .font(Font.system(size: self.defaultEmojiSize))
                    }
                    Button("Load Background") {
                        self.document.setBackgroundURL(URL(string: self.imageURL))
                    }
                }
            }
            .padding(.horizontal)
            
            emojiArtArea()
            
            //Color.white
            //.overlay(getBackgroundImageWithCompatability())
// Klappt leider beim alten XCode nicht -> iOS Target 13.2 unter Mojave. Umweg mittels func getBackgroundImageAsView
//                .overlay(
//                    Group {
//                        if self.document.backgroundImage != nil {
//                            Image(self.document.backgroundImage!)
//                        }
//                    }
//            )
              //  .edgesIgnoringSafeArea([.horizontal, .bottom])
        }
    }
    
    func emojiArtArea() -> some View {
        Group {
            if self.document.backgroundImage != nil {
                Color.white.overlay(Image(uiImage: self.document.backgroundImage!))
            } else {
                Color.white
            }
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
