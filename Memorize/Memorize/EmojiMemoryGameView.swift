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
             Grid(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    withAnimation(.linear(duration: 0.75)) {
                        self.viewModel.choose(card: card)
                    }
                }
                .padding(5)
            }
                .padding()
                .foregroundColor(extractColor())
                .onAppear(perform: { () -> Void in self.printTheme() })
            
            self.viewForThemenameAndPoints()
                
            Button("Start Game") {
                withAnimation(.easeInOut) {
                self.viewModel.startNewGame()
                }
            }
                .buttonStyle(DefaultButtonStyle())
                .padding()
        }
    }
    
    func extractColor() -> Color {
        Color(self.viewModel.themecolor)
    }
    
    func printTheme() {
        print(self.viewModel.themeAsJSON)
    }
    
    private func viewForThemenameAndPoints() -> some View {
        HStack {
            VStack (alignment: .leading) {
                HStack {
                    Text("Theme: ")
                        .font(.headline)
                        .bold()
                    Text("\(self.viewModel.themename)")
                        .foregroundColor(self.extractColor())
                }
                HStack {
                    Text("Points:")
                        .font(.headline)
                        .bold()
                    Text("\(viewModel.points)")
                        .frame(minWidth: 50.0)
                }
            }
            .frame(alignment: .leading)
            .padding()
            
            Spacer()
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
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
//                    printData()
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
        Group {
            EmojiMemoryGameView(viewModel: EmojiMemoryGame(theme: EmojiThemeFactory.themes[0]))
            EmojiMemoryGameView(viewModel: EmojiMemoryGame(theme: EmojiThemeFactory.themes[3]))
                .environment(\.locale, Locale(identifier: "ar"))
        }
    }
}

