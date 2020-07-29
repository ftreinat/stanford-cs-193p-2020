//
//  OptionalImage.swift
//  EmojiArt
//
//  Created by Florian Treinat on 28.07.20.
//  Copyright © 2020 Florian Treinat. All rights reserved.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        Group {
            if uiImage != nil {
                Image(uiImage: uiImage!)
            }
        }
    }
}
