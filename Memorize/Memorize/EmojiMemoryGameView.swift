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
  
    // TODO: Dieser Code compiliert nicht unter Mojace und Xcode 11.2.1.
    // stattdessen läuft nur der untere Code der das gleiche macht, aber nicht so schlank ist.
    
//    @ViewBuilder
//    private func body(for size: CGSize) -> some View {
//        if card.isFaceUp || !card.isMatched {
//            ZStack {
//                Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(110-90), clockwise: true)
//                    .padding(5).opacity(0.4)
//                Text(card.content)
//                    .font(Font.system(size: fontSize(for: size)))
//            }
//                .cardify(isFaceUp: card.isFaceUp)
//        }
//    }

    
    private func body(for size: CGSize) -> some View {
        Group {
            if card.isFaceUp || !card.isMatched {
                ZStack {
                    Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(110-90), clockwise: true)
                        .padding(5).opacity(0.4)
                    Text(card.content)
                        .font(Font.system(size: fontSize(for: size)))
                }
                    .cardify(isFaceUp: card.isFaceUp)
            } else {
                 EmptyView()
            }
        }
    }

    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * fontScaleFactor
    }
    
    // MARK: - Drawing Constants
    private let fontScaleFactor: CGFloat = 0.7

}

// erst relevant unter MacOS Catalina
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
    }
}
