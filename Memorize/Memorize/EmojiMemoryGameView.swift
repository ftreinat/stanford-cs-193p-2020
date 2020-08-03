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
                    withAnimation(.linear(duration: 0.75)) {
                        self.viewModel.choose(card: card)
                    }
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
                withAnimation(.easeInOut) {
                self.viewModel.startNewGame()
                }

            }
                .buttonStyle(DefaultButtonStyle())
                .padding()
        }
    }
    
    func extractColorFor(themecolor: UIColor) -> Color {
        Color(themecolor)
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
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    printData()
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaining*360-90), clockwise: true)
                            .onAppear {
                                self.startBonusTimeAnimation()
                            }
                    } else {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-card.bonusRemaining*360-90), clockwise: true)
                    }
                }
                .padding(5).opacity(0.4)
                .transition(.identity)
                
                Text(card.content)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
            }
                .cardify(isFaceUp: card.isFaceUp)
                .transition(AnyTransition.scale)
        }
    }

    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    // poor mans Logging inside SwiftUI Views, da alle Statements eigentlich Views sein müssen 
    func printData() -> some View {
        print("card \(card) mit AnimatedBonus: \(animatedBonusRemaining) und bonusRemaining \(card.bonusRemaining)")
        return EmptyView()
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
