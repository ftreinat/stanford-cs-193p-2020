//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Florian Treinat on 08.06.20.
//  Copyright © 2020 Florian Treinat. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack() {
             Grid(items: viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    self.viewModel.choose(card: card)
                }
                .padding(5)
            }
                .padding()
                .foregroundColor(extractColorFor(themecolor: self.viewModel.themecolor))
            HStack(alignment: VerticalAlignment.bottom) {
                Text("Theme: \(self.viewModel.themename)")
                Spacer()
                Text("Points: \(viewModel.points)")
            }.padding()
            Button("Start Game") {
                self.viewModel.startNewGame()
            }
                .buttonStyle(DefaultButtonStyle())
                .padding()
        }
    }
    
    func extractColorFor(themecolor: ThemeColor) -> Color {
        switch themecolor {
        case .green:
            return Color.green
        case .red:
            return Color.red
        case .blue:
            return Color.blue
        case .orange:
            return Color.orange
        }
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    func body(for size: CGSize) -> some View {
        ZStack() {
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                Text(card.content)
            } else {
                if !card.isMatched {
                    RoundedRectangle(cornerRadius: cornerRadius).fill()
                }
            }
        }
        .font(Font.system(size: fontSize(for: size)))

    }

    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * fontScaleFactor
    }
    
    // MARK: - Drawing Constants
    let cornerRadius: CGFloat = 10.0
    let edgeLineWidth: CGFloat = 3
    let fontScaleFactor: CGFloat = 0.75

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
