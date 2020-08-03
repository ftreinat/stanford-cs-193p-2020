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
    
    // MARK: View Drawing
    
    var body: some View {
//        \.self ist ein Keypath und gibt ein Attribut eines Objektes an. Hier self
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(EmojiArtDocument.palette.map { String($0) }, id: \.self) { emoji in
                        Text(emoji)
                            .font(Font.system(size: self.defaultEmojiSize))
                            .onDrag { NSItemProvider(object: emoji as NSString) }
                    }
                }
            }
            .padding(.horizontal)
            
            GeometryReader { geometry in
                ZStack {
                    Color.white.overlay(
                        OptionalImage(uiImage: self.document.backgroundImage)
                            .scaleEffect(self.zoomScale)
                            .offset(self.panOffset)
                    )
                    
                    if self.isLoading {
                        Image(systemName: "hourglass").imageScale(.large).spinning()
                    } else {
                        ForEach(self.document.emojis) { emoji in
                            self.body(for: emoji, in: geometry.size)
                                .transition(.move(edge: .top))
                        }
                    }
                }
                .clipped()
                .gesture(self.panGesture())
                .gesture(self.zoomGesture())
                .gesture(self.doubleTapToZoom(in: geometry.size).exclusively(before: self.singleTapToDeselect()))
                .edgesIgnoringSafeArea([.horizontal, .bottom])
                .onReceive(self.document.$backgroundImage) { image in
                    self.zoomToFit(image, in: geometry.size)
                }
                .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
                    // Global coordinatesystem in local (inside the ZStack
                    var location = geometry.convert(location, from: .global)
                    // Convert to coordinatesystem with (0,0) right in the middle and not top left corner
                    let originOfLocalCoordinateSystem = CGPoint(x: geometry.size.width/2, y: geometry.size.height/2)
                    location = CGPoint(x: location.x - originOfLocalCoordinateSystem.x, y: location.y - originOfLocalCoordinateSystem.y)
                    // handle offset for paning
                    location = CGPoint(x: location.x - self.panOffset.width, y: location.y - self.panOffset.height)
                    // handle offset for zooming
                    location = CGPoint(x: location.x / self.zoomScale, y:location.y / self.zoomScale)
                    return self.drop(providers: providers, at: location)
                }
            }
        }
    }
    
    // Draws the emoji view
    private func body(for emoji: Emoji, in size: CGSize) -> some View {
        Text(emoji.text)
            .font(animatableWithSize: emoji.fontSize * self.zoomScale)
            .border(self.selectionBorderColor, width: self.isEmojiSelected(emoji) ? self.selectionBorderWidth : 0)
            .scaleEffect(self.isEmojiSelected(emoji) ? self.gestureZoomScale.zoomScaleEmoji : 1.0)
            .position(self.position(for: emoji, in: size))
            .offset(self.isEmojiSelected(emoji) ? emojiMovementOffset : .zero)
            .gesture(self.selectGesture(for: emoji))
            .gesture(self.longPressToDelete(for: emoji).simultaneously(with: self.moveGesture(for: emoji, in: size)))
    }
    
    var isLoading: Bool {
        document.backgroundURL != nil && document.backgroundImage == nil 
    }
    
    private func rotation(for emoji: Emoji) -> Angle {
        if self.longPressGestureState.isDetectingLongPress && self.longPressGestureState.emojiToDelete?.id == emoji.id {
            return Angle.degrees(360)
        } else {
            return Angle.degrees(0)
        }
    }
    
    // MARK: View functions
    
    @State private var selectedEmojis: Set<Emoji> = Set()
    
    private func isEmojiSelected(_ emoji: Emoji) -> Bool {
        selectedEmojis.contains(matching: emoji) || emoji.id == currentlyDraggedEmoji?.id
    }
    
    private var isAnyEmojiSelected: Bool {
        !selectedEmojis.isEmpty
    }
    
    private func selectGesture(for emoji: Emoji ) -> some Gesture {
        return TapGesture(count: 1)
            .onEnded {
                self.selectedEmojis.toggle(matching: emoji)
        }
    }
    
    // MARK: Zoom/Pinch Gesture
    
    @State private var steadyStateZoomScale: CGFloat = 1.0
    @GestureState private var gestureZoomScale = PinchGestureState()

    private var zoomScale: CGFloat {
        steadyStateZoomScale * gestureZoomScale.zoomScaleBackground
    }
    
    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, transaction in
                if self.isAnyEmojiSelected {
                    gestureZoomScale.zoomScaleEmoji = latestGestureScale
                } else {
                    gestureZoomScale.zoomScaleBackground = latestGestureScale
                }
            }
            .onEnded { finalGestureScale in
                if self.isAnyEmojiSelected {
                    self.selectedEmojis.forEach {
                        self.document.scaleEmoji($0, by: finalGestureScale)
                    }
                } else {
                    self.steadyStateZoomScale *= finalGestureScale
                }
        }
    }
    
    // MARK: Pan Gesture
    
    @State private var steadyStatePanOffset: CGSize = .zero
    @GestureState private var gesturePanOffset: CGSize = .zero
    
    private var panOffset: CGSize {
        (steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    
    private func panGesture() -> some Gesture {
        return DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, transaction in
                gesturePanOffset = latestDragGestureValue.translation / self.zoomScale
            }
            .onEnded { finalDragGestureValue in
                self.steadyStatePanOffset = self.steadyStatePanOffset + (finalDragGestureValue.translation / self.zoomScale)
            }
    }
    
    //MARK: Emoji Drag Gesture
    
    @GestureState private var emojiMovementOffset: CGSize = .zero
    @State private var currentlyDraggedEmoji: Emoji?
    
    private func moveGesture(for emoji: Emoji, in size: CGSize) -> some Gesture {
        return DragGesture()
            .onChanged { changedDragGestureValue in
                if !self.isEmojiSelected(emoji) {
                    self.selectedEmojis.toggle(matching: emoji)
                }
            }
            .updating($emojiMovementOffset) { latestDragGestureValue, emojiMovementOffset, transaction in
                emojiMovementOffset = latestDragGestureValue.translation
            }
            .onEnded { finalDragGestureValue in
                for emojiToMove in self.selectedEmojis {
                    self.move(emoji: emojiToMove, by: finalDragGestureValue.translation / self.zoomScale)
                }
                if self.selectedEmojis.count == 1 {
                    self.selectedEmojis.removeFirst();
                }
            }
    }
    
    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                print("Zoom zoom")
                withAnimation {
                    self.zoomToFit(self.document.backgroundImage, in: size)
                }
            }
    }
    
    private func singleTapToDeselect() -> some Gesture {
        return TapGesture(count: 1)
            .onEnded {
                self.deselectAllEmojis()
        }
    }
    
    private func deselectAllEmojis() {
        self.selectedEmojis.removeAll()
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0 {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            self.steadyStatePanOffset = CGSize.zero
            self.steadyStateZoomScale = min(hZoom, vZoom)
        }
    }
    
    // Transformation from our (0,0) coordinatesystem in the middle to the iOS coordinate system with origin top left
    private func position(for emoji: Emoji, in size: CGSize) -> CGPoint {
        var location = emoji.location
        location = CGPoint(x: location.x * zoomScale, y: location.y * zoomScale)
        location = CGPoint(x: location.x + size.width/2, y: location.y + size.height/2)
        location = CGPoint(x: location.x + panOffset.width, y: location.y + panOffset.height)
        
        return location
    }
     
    private func move(emoji: Emoji, by offset: CGSize) {
        document.moveEmoji(emoji, by: offset)
    }
    
    private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            self.document.backgroundURL = url
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                withAnimation(.linear(duration: 1)) {
                self.document.addEmoji(string, at: location, size: self.defaultEmojiSize)
                }
            }
        }
        return found
    }
    
    // MARK: LongPress To Delete Gesture
    
    @GestureState private var longPressGestureState = LongPressGestureState()
    @State private var longPressSuccess = false
    
    private func longPressToDelete(for emoji: Emoji) -> some Gesture {
        return LongPressGesture(minimumDuration: 3)
            .updating($longPressGestureState) { currentState, gestureState, transaction in
                print("long press updating \(currentState)")
                gestureState.isDetectingLongPress = currentState
//                transaction.animation = Animation.easeOut(duration: 2.5)
                gestureState.emojiToDelete = emoji
            }
            .onEnded { finished in
                print("on endend long")
               
//                withAnimation(.linear(duration: 3)) {
                    self.longPressSuccess = finished
//                    self.document.deleteEmoji(emoji)
                self.remove(emoji)
//                }
            }
    }
    
    private func remove(_ emoji: Emoji) {
        withAnimation(.linear(duration: 2)) {
            document.deleteEmoji(emoji)
        }
    }
    
    private struct LongPressGestureState {
        var isDetectingLongPress = false
        var emojiToDelete: Emoji? = nil
    }
    
    // MARK: Drawing Constants
        
    private let defaultEmojiSize: CGFloat = 40
    private let selectionBorderColor: Color = Color.blue
    private let selectionBorderWidth: CGFloat = 2
}

extension Emoji {
    var fontSize: CGFloat { CGFloat(self.size) }
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}

// Helper struct for keeping the updated values of the pinch gesture for the background and emoji separate.
struct PinchGestureState {
    var zoomScaleBackground: CGFloat = 1.0
    var zoomScaleEmoji: CGFloat = 1.0
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        var document = EmojiArtDocument()
//        return EmojiArtDocumentView(document: document)
//    }
//}
