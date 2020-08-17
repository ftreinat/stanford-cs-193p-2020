//
//  EmojiCardThemeEditor.swift
//  Memorize
//
//  Created by Florian Treinat on 11.08.20.
//  Copyright © 2020 Florian Treinat. All rights reserved.
//

import SwiftUI

struct EmojiCardThemeEditor: View {
    @EnvironmentObject var store: MemorizeThemeStore
    
//    @Environment(\.presentationMode) var presentationMode
    
    var theme: EmojiCardTheme
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack {
            ZStack {
                Text(theme.name).font(.headline)
                HStack {
                    Spacer()
                    Button(action: {
//                        self.presentationMode.wrappedValue.dismiss()
                                  self.isShowing = false
                              }, label: { Text("Done") }).padding()
                }
            }
            Divider()
            Form {
                sectionForThemeName
                sectionForAddEmoji
                sectionForEmojiView
                sectionForPairAmount
                sectionForThemeColor
            }

        }
    }
    
    private var sectionForThemeColor: some View {
        Section(header: Text("Color")) {
            Grid(self.store.colorPalette, id: \.self) { color in
                ColorSelectionView(color: color, isSelected: self.theme.color == color)
                    .onTapGesture {
                        self.store.changeColor(of: self.theme, to: color)
                    }
            }
            .frame(height: self.heightForColorChooserView)
        }
    }
    
    private var heightForColorChooserView: CGFloat {
        // 70 Points per Row, at least two rows
        CGFloat((self.store.colorPalette.count / 5)) * 40 + 40
    }
    
    private var sectionForPairAmount: some View {
        Section(header: Text("Pair Count")) {
            HStack {
                Text("\(theme.numberOfPairs) pairs")
                Spacer()
                Stepper(onIncrement: { self.store.incrementNumberOfPairs(of: self.theme) }, onDecrement: { self.store.decrementNumberOfPairs(of: self.theme) }, label: { EmptyView() } )
                
            }
        }
    }
    
    private var sectionForThemeName: some View {
        Section(header: Text("Theme name")) {
            EditableText(theme.name, isEditing: true) { name in
                print("new name \(name)")
                self.store.changeName(of: self.theme, to: name)
            }
        }
    }
    
    @State private var isValidEmojiInput = false
    @State private var emojiToAddNew = ""
    
    private var sectionForAddEmoji: some View {
        Section(header: Text("Add emoji") ) {
            HStack {
                TextField("Emoji", text: $emojiToAddNew, onEditingChanged: { began in
                    if !began {
                        self.store.addEmoji(self.emojiToAddNew, to: self.theme)
                        self.emojiToAddNew = ""
                    }
                })
                Spacer()
                Button(action: {
                    if !self.emojiToAddNew.isEmpty {
                        self.store.addEmoji(self.emojiToAddNew, to: self.theme)
                        self.emojiToAddNew = ""
                    }
                })
                {
                    Text("Add")
                }
            }
         }
    }
    
    @State private var showMinimumEmojiAlert = false
    
    private var sectionForEmojiView: some View {
        Section(header:
            HStack {
                Text("Emojis")
                Spacer()
                Text("Tap to remove")
                    .font(Font.system(size: annotationFontSize))
                    .foregroundColor(Color.blue)
            }
        ) {
            Grid(theme.emojis, id: \.self) { emoji in
                Text(emoji)
                    .font(Font.system(size: self.emojiSelectionSize))
                    .padding(1.0)
                    .onTapGesture {
                        if self.store.isEmojiRemovalAllowed(for: self.theme) {
                            self.store.removeEmoji(emoji, from: self.theme)
                        } else {
                            self.showMinimumEmojiAlert = true
                        }
                    }
            }
            .frame(height: self.heightForEmojiView)
            .alert(isPresented: self.$showMinimumEmojiAlert) {
                Alert(title: Text("Cannot remove emoji"),
                      message: Text("At least two emojis have to reside in an emoji theme."),
                      dismissButton: Alert.Button.default(Text("OK"), action: { self.showMinimumEmojiAlert = false })
                )
            }
        }
    }
    
    private var heightForEmojiView: CGFloat {
        // 70 Points per Row, at least two rows
        CGFloat((theme.emojis.count /  5)) * 70 + 70
    }
    
    //MARK: Drawing Constants
    let annotationFontSize: CGFloat = 10.0
    let emojiSelectionSize: CGFloat = 45.0
}

struct ColorSelectionView : View {
    var color: UIColor
    var isSelected = false
    
    var body: some View {
        Color(color)
            .frame(width: 30.0, height: 30.0)
            .cornerRadius(5.0)
            .border(Color.black, width: isSelected ? 3 : 0)
            .cornerRadius(5.0)
    }
}

struct EmojiCardThemeEditor_Previews: PreviewProvider {
    static var previews: some View {
        EmojiCardThemeEditor(theme: EmojiThemeFactory.themes[2]
            , isShowing: Binding.constant(true))
        .environmentObject(MemorizeThemeStore())
    }
}
