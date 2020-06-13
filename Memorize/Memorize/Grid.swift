//
//  Grid.swift
//  Memorize
//
//  Created by Florian Treinat on 12.06.20.
//  Copyright © 2020 Florian Treinat. All rights reserved.
//

import SwiftUI

// where Identfiable ist notwendig, damit ForEach funktioniert
struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    var items: [Item]
    var viewForItem: (Item) -> ItemView
    
    init(items: [Item], viewForItem: @escaping (Item) -> ItemView) {
        self.items = items;
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: GridLayout(itemCount: self.items.count, in: geometry.size))
        }
    }
    
    func body(for layout: GridLayout) -> some View {
        ForEach(items) { item in
            self.body(for: item, in: layout)
        }
    }
    
    func body(for item: Item, in layout: GridLayout) -> some View {
        let index = items.firstIndex(matching: item)
//        return Group {
//            if index != nil {
//                viewForItem(item)
//                    .frame(width: layout.itemSize.width, height: layout.itemSize.height)
//                    .position(layout.location(ofItemAt: index!))
//            }
//
//            // sollte es nil sein, was es nie ist dann wird ein EmptyView zurückgegeben. Dies ist Bestandteil von Group
//        }
        //        return Group {
        return viewForItem(item)
            .frame(width: layout.itemSize.width, height: layout.itemSize.height)
            .position(layout.location(ofItemAt: index!))
    }
    
}
