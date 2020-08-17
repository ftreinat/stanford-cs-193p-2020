//
//  MemorizeThemeChooserView.swift
//  Memorize
//
//  Created by Florian Treinat on 07.08.20.
//  Copyright © 2020 Florian Treinat. All rights reserved.
//

import SwiftUI

struct MemorizeThemeChooserView: View {
    @EnvironmentObject var store: MemorizeThemeStore
    
    @State private var editmode: EditMode = .inactive
// Presentation mode has to be inherited by this view, the presenter view, as well. Otherwise the navigationbar buttons became unclickable after showing the sheet seems to be a bug in swiftui. See also https://gist.github.com/gevorgyanvahagn/3f60543a8a5ed5a40edabe00a2d770da and https://stackoverflow.com/questions/58512344/swiftui-navigation-bar-button-not-clickable-after-sheet-has-been-presented
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    NavigationLink(destination: EmojiMemoryGameView(viewModel: EmojiMemoryGame(theme: theme))
                        .navigationBarTitle(Text("\(theme.name)"), displayMode: .inline)
                    ) {
                        ThemeChooserRow(theme: theme, editmode: self.$editmode)
                            .environmentObject(self.store)
                    }
                }
                .onDelete { indexSet in
                    indexSet.map { self.store.themes[$0] }.forEach { theme in
                        self.store.deleteTheme(theme)
                    }
                }
            }
            .navigationBarTitle("Themes")
            .navigationBarItems(
                leading: Button(action: {
                    self.store.addNewTheme()
                }, label: {
                    Image(systemName: "plus").imageScale(.large)
                }),
                trailing: EditButton()
            )
            .environment(\.editMode, $editmode)
        }
    }
}

struct ThemeChooserRow: View {
    @EnvironmentObject var store: MemorizeThemeStore
    var theme: EmojiCardTheme
    
    @Binding var editmode: EditMode
    
    @State var showThemeEditor = false
    
    var body: some View {
        HStack {
            if self.editmode.isEditing {
                Image(systemName: "pencil")
                    .font(.title)
                    .padding(4.0)
                    .shadow(color: .gray, radius: 1, x: 4, y: 2)
                    .onTapGesture {
                        if self.editmode.isEditing {
                            self.showThemeEditor = true
                        }
                    }
            }
            VStack (alignment: .leading) {
            Text(theme.name)
                .foregroundColor(Color(theme.color))
                .lineLimit(1)

            HStack (alignment: .center) {
                Text("\(theme.numberOfPairs) Pairs of")
                    .font(.subheadline)
                Text(self.emojiSample(of: theme))
                    .font(.subheadline)
                    .lineLimit(1)
            }
            }
            Spacer()
            ColorSelectionView(color: theme.color)

                
            }
            .lineLimit(1)
            .sheet(isPresented: self.$showThemeEditor) {
                EmojiCardThemeEditor(theme: self.theme, isShowing: self.$showThemeEditor)
                .environmentObject(self.store)
        }
    }
    
    private func emojiSample(of theme: EmojiCardTheme) -> String {
        return theme.emojis[0...min(5,theme.emojis.count-1)].joined(separator: " ")
    }
    
    private let themeTitleWidth: CGFloat = 100.0
}

struct MemorizeThemeChooserView_Previews: PreviewProvider {
    static var previews: some View {
        MemorizeThemeChooserView()
        .environmentObject(MemorizeThemeStore())
    }
}
